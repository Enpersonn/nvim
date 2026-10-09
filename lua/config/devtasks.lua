local M = {}

local function in_zellij()
	return vim.env.ZELLIJ ~= nil and vim.env.ZELLIJ_SESSION_NAME ~= nil
end

local function notify_result(label, result)
	vim.schedule(function()
		local output = vim.trim((result.stdout or "") .. (result.stderr or ""))
		if result.code == 0 then
			vim.notify(output ~= "" and output or label, vim.log.levels.INFO, { title = "Project tasks" })
		else
			vim.notify(output ~= "" and output or (label .. " failed"), vim.log.levels.ERROR, { title = "Project tasks" })
		end
	end)
end

local function run(args, label)
	if not in_zellij() then
		vim.notify("Project tasks require a Zellij session", vim.log.levels.WARN)
		return
	end

	local command = { "devtasks" }
	vim.list_extend(command, args)
	vim.system(command, { cwd = vim.fn.getcwd(), text = true }, function(result)
		notify_result(label, result)
	end)
end

local function open_menu()
	if not in_zellij() then
		vim.notify("Project tasks require a Zellij session", vim.log.levels.WARN)
		return
	end

	vim.system({
		"zellij",
		"run",
		"--floating",
		"--close-on-exit",
		"--name",
		"Project tasks",
		"--cwd",
		vim.fn.getcwd(),
		"--width",
		"60%",
		"--height",
		"60%",
		"--",
		"devtasks",
		"menu",
	}, { text = true }, function(result)
		if result.code ~= 0 then
			notify_result("Could not open task menu", result)
		end
	end)
end

vim.api.nvim_create_user_command("DevTasks", open_menu, { desc = "Open project task menu" })
vim.api.nvim_create_user_command("DevStart", function(options)
	run(vim.list_extend({ "start" }, options.fargs), "Project tasks started")
end, { nargs = "*", desc = "Start default or named project tasks" })
vim.api.nvim_create_user_command("DevStop", function(options)
	run(vim.list_extend({ "stop" }, options.fargs), "Project tasks stopped")
end, { nargs = "*", desc = "Stop default or named project tasks" })
vim.api.nvim_create_user_command("DevRestart", function(options)
	run(vim.list_extend({ "restart" }, options.fargs), "Project tasks restarted")
end, { nargs = "*", desc = "Restart default or named project tasks" })
vim.api.nvim_create_user_command("DevLogs", function(options)
	run(vim.list_extend({ "logs" }, options.fargs), "Task logs opened")
end, { nargs = "?", desc = "Show project task logs" })

vim.keymap.set("n", "<leader>rr", open_menu, { desc = "Run: select project task" })
vim.keymap.set("n", "<leader>rd", function()
	run({ "start" }, "Project tasks started")
end, { desc = "Run: start defaults" })
vim.keymap.set("n", "<leader>rs", function()
	run({ "stop" }, "Project tasks stopped")
end, { desc = "Run: stop defaults" })
vim.keymap.set("n", "<leader>rl", function()
	run({ "logs" }, "Task logs opened")
end, { desc = "Run: show logs" })

return M
