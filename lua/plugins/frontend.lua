return {

	{ "nvim-telescope/telescope.nvim",   dependencies = { "nvim-lua/plenary.nvim" } },

	{ "nvim-tree/nvim-tree.lua",         dependencies = { "nvim-tree/nvim-web-devicons" } },

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	{ "nvimtools/none-ls.nvim",          dependencies = { "nvim-lua/plenary.nvim" } },

	{ "nvim-lualine/lualine.nvim" },

	{ "lewis6991/gitsigns.nvim" },

	{ "folke/tokyonight.nvim" },

	{ "ThePrimeagen/vim-be-good",        cmd = "VimBeGood" },
}
