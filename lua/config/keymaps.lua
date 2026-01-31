local map = vim.keymap.set
local diag = vim.diagnostic
local buf = vim.lsp.buf
local fyler = require("fyler")
local builtin = require("telescope.builtin")

map("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live Grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help Tags" })

map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
map("n", "<leader>fw", builtin.grep_string, { desc = "Grep Word Under Cursor" })

map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })

map("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
map("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
map("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })

map("n", "<leader>fc", builtin.command_history, { desc = "Command History" })

map("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })

map("n", "<leader>fl", builtin.diagnostics, { desc = "Telescope diagnostics" })

map("n", "<leader>e", function()
	fyler.focus()
end)
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "toggles terminal overlay" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf }

		buf.format({ async = false })

		map("n", "<leader>F", buf.format, { desc = "Format current file" })
		map("n", "gd", buf.definition, opts)
		map("n", "K", buf.hover, opts)
		map("n", "gi", buf.implementation, opts)
		map("n", "<leader>rn", buf.rename, opts)
		map("n", "<leader>ca", buf.code_action, opts)
		map("n", "[d", diag.goto_prev, opts)
		map("n", "]d", diag.goto_next, opts)
		map("n", "<leader>d", vim.diagnostic.open_float, opts)
	end,
})
