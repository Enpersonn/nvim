return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	branch = "stable",
	lazy = false,
	config = function()
		require("fyler").setup({
			views = {
				explorer = {
					position = "left",
					width = 30,
					close_if_last_window = true,
				},
			},
			integrations = {
				icons = "mini_icons",
			},
		})
	end,
}
