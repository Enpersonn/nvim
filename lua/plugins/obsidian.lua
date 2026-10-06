return {
	"obsidian-nvim/obsidian.nvim",
	version = "v3.16.8",
	ft = "markdown",
	cmd = "Obsidian",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "notes",
				path = "~/Notes",
			},
		},
		new_notes_location = "notes_subdir",
		notes_subdir = "Inbox",
		daily_notes = {
			folder = "Daily",
			workdays_only = false,
		},
		templates = {
			folder = "Templates",
		},
		picker = {
			name = "telescope.nvim",
		},
		-- Avoid a Neovim 0.12/nvim-treesitter markdown conceal incompatibility.
		ui = {
			enable = false,
		},
	},
	keys = {
		{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: New note" },
		{ "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian: Today" },
		{ "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: Quick switch" },
		{ "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian: Search" },
		{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: Backlinks" },
	},
}
