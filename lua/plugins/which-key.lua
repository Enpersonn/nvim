return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 300,
		spec = {
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Git hunks" },
			{ "<leader>n", group = ".NET" },
			{ "<leader>nt", group = ".NET tests" },
			{ "<leader>o", group = "Obsidian" },
			{ "<leader>t", group = "Toggle" },
		},
	},
}
