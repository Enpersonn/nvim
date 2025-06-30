return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		opts = {
			variant = "moon",
			dark_variant = "moon",
			styles = {
				transparent = true,
			},
		},
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				disable_float_background = true,
			})
			vim.cmd.colorscheme("rose-pine")
		end,
	},
}
