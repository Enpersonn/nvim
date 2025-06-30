return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "tsserver", "jsonls", "html" },
			})
		end,
	},

	{ 
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
	},
}
