return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			globalstatus = true,
		},
		sections = {
			lualine_b = { "branch", "diff", "diagnostics" },
		},
	},
}
