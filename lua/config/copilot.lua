require("copilot").setup {
	suggestion = {

		auto_trigger = true,
		enable = not vim.g.ai_cmp,
		keymap = {
			accept = "<C-l>",
			next = "<C-]>",
			prve = "<C-[>",
			dismiss = "<C-/>",
		},
	},
	filetypes = {
		markdown = true,
		terraform = false,
		sh = function()
			if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
				return false
			end
			return true
		end,
	},
}
