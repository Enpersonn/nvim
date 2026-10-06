return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = { "saghen/blink.cmp" },
	config = function()
		require("config.lsp")
	end,
}
