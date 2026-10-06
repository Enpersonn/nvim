return {
	"smart-splits-nvim/smart-splits.nvim",
	lazy = false,
	config = function()
		local smart_splits = require("smart-splits")

		smart_splits.setup({
			multiplexer_integration = "zellij",
			zellij_move_focus_or_tab = false,
		})

		vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move left" })
		vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move down" })
		vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move up" })
		vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move right" })
	end,
}
