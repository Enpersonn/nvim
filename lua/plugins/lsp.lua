return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = { "saghen/blink.cmp", { "b0o/SchemaStore.nvim", version = false } },
	config = function()
		require("config.lsp")
	end,
}
