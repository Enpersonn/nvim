local M = {}

local namespace = vim.api.nvim_create_namespace("ProjectDashboard")
local state = nil

local function joinpath(...)
	return table.concat({ ... }, "/"):gsub("//+", "/")
end

local function exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function trim_to(text, width)
	text = text:gsub("%s+", " ")
	if vim.fn.strdisplaywidth(text) <= width then
		return text
	end
	return vim.fn.strcharpart(text, 0, math.max(width - 1, 1)) .. "…"
end

local function project_file(cwd, suffix)
	return exists(joinpath(cwd, suffix))
end

local function detect_project(cwd)
	local kinds = {}
	local markers = {}
	local manager = nil

	if project_file(cwd, "package.json") then
		table.insert(kinds, "Node")
		table.insert(markers, "package.json")
		if project_file(cwd, "pnpm-lock.yaml") then
			manager = "pnpm"
		elseif project_file(cwd, "yarn.lock") then
			manager = "yarn"
		elseif project_file(cwd, "bun.lock") or project_file(cwd, "bun.lockb") then
			manager = "bun"
		else
			manager = "npm"
		end
	end
	if project_file(cwd, "tsconfig.json") then
		table.insert(kinds, "TypeScript")
		table.insert(markers, "tsconfig.json")
	end
	if project_file(cwd, ".luarc.json") or project_file(cwd, "init.lua") then
		table.insert(kinds, "Lua")
		table.insert(markers, project_file(cwd, ".luarc.json") and ".luarc.json" or "init.lua")
	end
	if project_file(cwd, "Cargo.toml") then
		table.insert(kinds, "Rust")
		table.insert(markers, "Cargo.toml")
	end
	if project_file(cwd, "go.mod") then
		table.insert(kinds, "Go")
		table.insert(markers, "go.mod")
	end
	if project_file(cwd, "pyproject.toml") or project_file(cwd, "requirements.txt") then
		table.insert(kinds, "Python")
		table.insert(markers, project_file(cwd, "pyproject.toml") and "pyproject.toml" or "requirements.txt")
	end

	for name, type in vim.fs.dir(cwd) do
		if type == "file" and (name:match("%.sln$") or name:match("%.csproj$")) then
			table.insert(kinds, ".NET")
			table.insert(markers, name)
			break
		end
	end

	if #kinds == 0 then
		table.insert(kinds, "General project")
	end

	return {
		label = table.concat(kinds, " · "),
		markers = markers,
		manager = manager,
	}
end

local function package_tasks(cwd, manager)
	local path = joinpath(cwd, "package.json")
	if not exists(path) then
		return {}
	end

	local ok_lines, lines = pcall(vim.fn.readfile, path)
	if not ok_lines then
		return {}
	end
	local ok_json, package = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not ok_json or type(package) ~= "table" or type(package.scripts) ~= "table" then
		return {}
	end

	local tasks = {}
	local seen = {}
	local preferred = { "dev", "start", "test", "build", "lint", "typecheck", "format" }
	local names = {}
	for _, name in ipairs(preferred) do
		if package.scripts[name] then
			table.insert(names, name)
			seen[name] = true
		end
	end
	local remaining = vim.tbl_keys(package.scripts)
	table.sort(remaining)
	for _, name in ipairs(remaining) do
		if not seen[name] then
			table.insert(names, name)
		end
	end

	for _, name in ipairs(names) do
		if #tasks >= 7 then
			break
		end
		local command
		if manager == "yarn" then
			command = { "yarn", name }
		else
			command = { manager or "npm", "run", name }
		end
		table.insert(tasks, { label = (manager or "npm") .. " " .. name, command = command })
	end
	return tasks
end

local function detect_tasks(cwd, project)
	local tasks = package_tasks(cwd, project.manager)
	local function add(label, command)
		if #tasks < 9 then
			table.insert(tasks, { label = label, command = command })
		end
	end

	if project_file(cwd, "Cargo.toml") then
		add("cargo run", { "cargo", "run" })
		add("cargo test", { "cargo", "test" })
		add("cargo check", { "cargo", "check" })
	elseif project_file(cwd, "go.mod") then
		add("go run ./...", { "go", "run", "./..." })
		add("go test ./...", { "go", "test", "./..." })
		add("go build ./...", { "go", "build", "./..." })
	elseif project_file(cwd, "pyproject.toml") or project_file(cwd, "requirements.txt") then
		local prefix = project_file(cwd, "uv.lock") and { "uv", "run" } or {}
		local test = vim.list_extend(vim.deepcopy(prefix), { "python", "-m", "pytest" })
		if #prefix > 0 then
			test = { "uv", "run", "pytest" }
		end
		add(table.concat(test, " "), test)
	end

	local has_dotnet = false
	for _, marker in ipairs(project.markers) do
		if marker:match("%.sln$") or marker:match("%.csproj$") then
			has_dotnet = true
			break
		end
	end
	if has_dotnet then
		add("dotnet run", { "dotnet", "run" })
		add("dotnet test", { "dotnet", "test" })
		add("dotnet build", { "dotnet", "build" })
	end
	if project_file(cwd, "Makefile") then
		add("make", { "make" })
	end

	return tasks
end

local function read_overview(cwd)
	local readme
	for _, name in ipairs({ "README.md", "README", "readme.md" }) do
		if project_file(cwd, name) then
			readme = joinpath(cwd, name)
			break
		end
	end
	if not readme then
		return nil
	end

	local ok, lines = pcall(vim.fn.readfile, readme, "", 50)
	if not ok then
		return nil
	end
	for _, line in ipairs(lines) do
		local text = vim.trim(line)
		if
			text ~= ""
			and not text:match("^#")
			and not text:match("^!")
			and not text:match("^%[!")
			and not text:match("^<")
			and not text:match("^```")
		then
			return text
		end
	end
	return nil
end

local function recent_files(cwd)
	local result = {}
	local seen = {}
	local root = vim.uv.fs_realpath(cwd) or cwd
	root = root:gsub("/+$", "") .. "/"

	for _, oldfile in ipairs(vim.v.oldfiles or {}) do
		local path = vim.uv.fs_realpath(vim.fn.expand(oldfile))
		if path and path:sub(1, #root) == root and vim.fn.filereadable(path) == 1 and not seen[path] then
			seen[path] = true
			table.insert(result, { path = path, display = path:sub(#root + 1) })
			if #result == 5 then
				break
			end
		end
	end
	return result
end

local function diagnostic_summary()
	local counts = { errors = 0, warnings = 0 }
	for _, diagnostic in ipairs(vim.diagnostic.get()) do
		if diagnostic.severity == vim.diagnostic.severity.ERROR then
			counts.errors = counts.errors + 1
		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
			counts.warnings = counts.warnings + 1
		end
	end
	return counts
end

local function render()
	if not state or not vim.api.nvim_buf_is_valid(state.buf) then
		return
	end

	local lines = {}
	local highlights = {}
	local actions = {}
	local width = math.max(52, math.min(92, vim.o.columns - 6))
	local left = math.max(math.floor((vim.o.columns - width) / 2), 0)
	local pad = string.rep(" ", left)

	local function add(text, highlight, action)
		text = pad .. (text or "")
		table.insert(lines, text)
		if highlight then
			table.insert(highlights, { #lines - 1, highlight })
		end
		if action then
			actions[#lines] = action
		end
	end

	local function section(title)
		add("")
		add(title, "ProjectDashboardSection")
	end

	add(trim_to(vim.fs.basename(state.cwd), width), "ProjectDashboardTitle")
	add(trim_to(state.cwd, width), "ProjectDashboardPath")
	local details = state.project.label
	if state.project.manager then
		details = details .. "  •  " .. state.project.manager
	end
	add(trim_to(details, width), "ProjectDashboardInfo")
	if state.overview then
		add(trim_to(state.overview, width), "ProjectDashboardMuted")
	end

	section("Git")
	if state.git.loading then
		add("  Loading repository information…", "ProjectDashboardMuted")
	elseif not state.git.is_repo then
		add("  Not a Git repository", "ProjectDashboardMuted")
	else
		local branch = "   " .. (state.git.branch or "detached")
		if state.git.ahead > 0 then
			branch = branch .. "  ↑" .. state.git.ahead
		end
		if state.git.behind > 0 then
			branch = branch .. "  ↓" .. state.git.behind
		end
		local summary = {}
		if state.git.staged > 0 then
			table.insert(summary, state.git.staged .. " staged")
		end
		if state.git.modified > 0 then
			table.insert(summary, state.git.modified .. " modified")
		end
		if state.git.untracked > 0 then
			table.insert(summary, state.git.untracked .. " untracked")
		end
		branch = branch .. "  •  " .. (#summary > 0 and table.concat(summary, " · ") or "clean")
		add(trim_to(branch, width), "ProjectDashboardInfo")
		if state.git.commit then
			add(trim_to("  " .. state.git.commit, width), "ProjectDashboardMuted")
		end
		for index, item in ipairs(state.git.files) do
			if index > 5 then
				add("    … and " .. (#state.git.files - 5) .. " more", "ProjectDashboardMuted")
				break
			end
			local file = item.path
			add(trim_to(string.format("    %-2s %s", item.code, file), width), "ProjectDashboardChanged", function()
				vim.cmd.edit(vim.fn.fnameescape(joinpath(state.cwd, file)))
			end)
		end
	end

	section("Recent project files")
	if #state.recent == 0 then
		add("  No project files in Neovim's history yet", "ProjectDashboardMuted")
	else
		for index, item in ipairs(state.recent) do
			add(trim_to(string.format("  [%d] %s", index, item.display), width), nil, function()
				vim.cmd.edit(vim.fn.fnameescape(item.path))
			end)
		end
	end

	section("Project tasks")
	if #state.tasks == 0 then
		add("  [t] Open project task menu", nil, function()
			vim.cmd("DevTasks")
		end)
	else
		local task_names = vim.tbl_map(function(task)
			return task.label
		end, state.tasks)
		add("  [t] Choose and run a task", nil, M.choose_task)
		add(trim_to("      " .. table.concat(task_names, "  •  "), width), "ProjectDashboardMuted")
	end

	section("Actions")
	add("  [f] Find files       [g] Search text       [e] File explorer")
	add("  [s] Git status       [d] Diagnostics       [r] Recent files")
	add("  [R] Refresh          [l] Lazy plugins      [q] Quit")

	local diagnostics = diagnostic_summary()
	add("")
	local diagnostic_text
	if diagnostics.errors == 0 and diagnostics.warnings == 0 then
		diagnostic_text = "Diagnostics: none loaded (language servers start when files open)"
	else
		diagnostic_text = string.format("Diagnostics: %d errors · %d warnings", diagnostics.errors, diagnostics.warnings)
	end
	add(diagnostic_text, "ProjectDashboardMuted")
	add("Press a highlighted key, or move to an item and press <Enter>", "ProjectDashboardMuted")

	state.line_actions = actions
	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(state.buf, namespace, 0, -1)
	for _, item in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(state.buf, namespace, item[2], item[1], 0, -1)
	end
	for line_number, line in ipairs(lines) do
		local start = 1
		while true do
			local first, last = line:find("%[[%w]%]", start)
			if not first then
				break
			end
			vim.api.nvim_buf_add_highlight(state.buf, namespace, "ProjectDashboardKey", line_number - 1, first - 1, last)
			start = last + 1
		end
	end
	vim.bo[state.buf].modifiable = false
end

local function parse_git_status(output)
	local git = {
		loading = false,
		is_repo = true,
		branch = "detached",
		ahead = 0,
		behind = 0,
		staged = 0,
		modified = 0,
		untracked = 0,
		files = {},
	}
	local lines = vim.split(output or "", "\n", { trimempty = true })
	local heading = table.remove(lines, 1) or ""
	local head = heading:gsub("^## ", "")
	git.branch = head:match("^No commits yet on (.+)$") or head:match("^(.-)%.%.%.") or head:match("^(%S+)") or "detached"
	if git.branch == "HEAD" then
		git.branch = "detached"
	end
	git.ahead = tonumber(head:match("ahead (%d+)")) or 0
	git.behind = tonumber(head:match("behind (%d+)")) or 0

	for _, line in ipairs(lines) do
		local code = line:sub(1, 2)
		local path = line:sub(4)
		path = path:match("^.+ %-> (.+)$") or path
		if code == "??" then
			git.untracked = git.untracked + 1
		else
			if code:sub(1, 1) ~= " " then
				git.staged = git.staged + 1
			end
			if code:sub(2, 2) ~= " " then
				git.modified = git.modified + 1
			end
		end
		table.insert(git.files, { code = code, path = path })
	end
	return git
end

local function refresh_git(generation)
	vim.system({ "git", "status", "--short", "--branch" }, { cwd = state.cwd, text = true }, function(result)
		vim.schedule(function()
			if not state or state.generation ~= generation or not vim.api.nvim_buf_is_valid(state.buf) then
				return
			end
			if result.code ~= 0 then
				state.git = { loading = false, is_repo = false, files = {} }
			else
				local commit = state.git.commit
				state.git = parse_git_status(result.stdout)
				state.git.commit = commit
			end
			render()
		end)
	end)

	vim.system({ "git", "log", "-1", "--format=%h  %s  (%cr)" }, { cwd = state.cwd, text = true }, function(result)
		vim.schedule(function()
			if not state or state.generation ~= generation or not vim.api.nvim_buf_is_valid(state.buf) then
				return
			end
			if result.code == 0 then
				state.git.commit = vim.trim(result.stdout)
			end
			render()
		end)
	end)
end

function M.refresh()
	if not state then
		return
	end
	state.generation = state.generation + 1
	state.project = detect_project(state.cwd)
	state.tasks = detect_tasks(state.cwd, state.project)
	state.recent = recent_files(state.cwd)
	state.overview = read_overview(state.cwd)
	state.git = { loading = true, is_repo = false, files = {} }
	render()
	refresh_git(state.generation)
end

local function run_task(task)
	vim.cmd("botright 12new")
	local job = vim.fn.jobstart(task.command, {
		cwd = state.cwd,
		term = true,
	})
	if job <= 0 then
		vim.notify("Could not start " .. task.label, vim.log.levels.ERROR, { title = "Project dashboard" })
		return
	end
	vim.cmd.startinsert()
end

function M.choose_task()
	if not state or #state.tasks == 0 then
		vim.cmd("DevTasks")
		return
	end
	vim.ui.select(state.tasks, {
		prompt = "Run project task",
		format_item = function(task)
			return task.label
		end,
	}, function(task)
		if task then
			run_task(task)
		end
	end)
end

local function telescope(picker)
	vim.cmd("Telescope " .. picker)
end

local function set_keymaps(buf)
	local function map(key, callback, description)
		vim.keymap.set("n", key, callback, { buffer = buf, nowait = true, silent = true, desc = description })
	end

	map("f", function()
		telescope("find_files")
	end, "Dashboard: find files")
	map("g", function()
		telescope("live_grep")
	end, "Dashboard: search text")
	map("r", function()
		telescope("oldfiles")
	end, "Dashboard: recent files")
	map("s", function()
		if state.git.is_repo then
			telescope("git_status")
		else
			vim.notify("This directory is not a Git repository", vim.log.levels.INFO)
		end
	end, "Dashboard: Git status")
	map("d", function()
		telescope("diagnostics")
	end, "Dashboard: diagnostics")
	map("e", function()
		require("lazy").load({ plugins = { "fyler.nvim" } })
		require("fyler").open()
	end, "Dashboard: file explorer")
	map("t", M.choose_task, "Dashboard: project tasks")
	map("R", M.refresh, "Dashboard: refresh")
	map("l", "<cmd>Lazy<cr>", "Dashboard: plugins")
	map("q", "<cmd>quit<cr>", "Dashboard: quit")
	map("<CR>", function()
		local action = state.line_actions[vim.api.nvim_win_get_cursor(0)[1]]
		if action then
			action()
		end
	end, "Dashboard: open item")
	for index = 1, 5 do
		map(tostring(index), function()
			local item = state.recent[index]
			if item then
				vim.cmd.edit(vim.fn.fnameescape(item.path))
			end
		end, "Dashboard: open recent file " .. index)
	end
end

function M.open()
	local cwd = vim.uv.cwd() or vim.fn.getcwd()
	local current = vim.api.nvim_get_current_buf()
	local can_reuse = vim.api.nvim_buf_get_name(current) == ""
		and vim.bo[current].buftype == ""
		and not vim.bo[current].modified
		and vim.api.nvim_buf_line_count(current) == 1
		and vim.api.nvim_buf_get_lines(current, 0, 1, false)[1] == ""
	if not can_reuse then
		current = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(current)
	end

	vim.api.nvim_buf_set_name(current, "project-dashboard://" .. cwd)
	vim.bo[current].buftype = "nofile"
	vim.bo[current].bufhidden = "wipe"
	vim.bo[current].swapfile = false
	vim.bo[current].buflisted = false
	vim.bo[current].undofile = false
	vim.bo[current].filetype = "projectdashboard"
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.signcolumn = "no"
	vim.wo.foldcolumn = "0"
	vim.wo.cursorline = false
	vim.wo.list = false

	state = {
		buf = current,
		cwd = cwd,
		generation = 0,
		line_actions = {},
		git = { loading = true, is_repo = false, files = {} },
	}
	set_keymaps(current)
	M.refresh()
end

local function should_open_at_startup()
	if vim.fn.argc() ~= 0 then
		return false
	end
	local buf = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_name(buf) == ""
		and vim.bo[buf].buftype == ""
		and vim.api.nvim_buf_line_count(buf) == 1
		and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
end

function M.setup()
	vim.api.nvim_set_hl(0, "ProjectDashboardTitle", { link = "Title", default = true })
	vim.api.nvim_set_hl(0, "ProjectDashboardSection", { link = "Function", default = true })
	vim.api.nvim_set_hl(0, "ProjectDashboardPath", { link = "Directory", default = true })
	vim.api.nvim_set_hl(0, "ProjectDashboardInfo", { link = "Normal", default = true })
	vim.api.nvim_set_hl(0, "ProjectDashboardMuted", { link = "Comment", default = true })
	vim.api.nvim_set_hl(0, "ProjectDashboardKey", { link = "Special", default = true })
	vim.api.nvim_set_hl(0, "ProjectDashboardChanged", { link = "Changed", default = true })

	local group = vim.api.nvim_create_augroup("ProjectDashboard", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		callback = function()
			if should_open_at_startup() then
				M.open()
			end
		end,
	})
	vim.api.nvim_create_autocmd({ "VimResized", "DiagnosticChanged" }, {
		group = group,
		callback = function()
			if state and vim.api.nvim_buf_is_valid(state.buf) then
				render()
			end
		end,
	})
	vim.api.nvim_create_user_command("Dashboard", M.open, { desc = "Open the project dashboard" })
end

return M
