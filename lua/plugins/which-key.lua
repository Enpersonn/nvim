return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 300,
		spec = {
			{ "<leader>d", group = "Debug" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Git hunks" },
			{ "<leader>n", group = ".NET" },
			{ "<leader>nt", group = ".NET tests" },
			{ "<leader>o", group = "Obsidian" },
			{ "<leader>r", group = "Run" },
			{ "<leader>t", group = "Toggle" },
		},
	},
}
