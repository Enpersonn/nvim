-- Get blink.cmp capabilities
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config['biome'] = {
	capabilities = capabilities,
	cmd = { "biome", "lsp-proxy" },
	filetypes = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"svelte",
		"typescript",
		"typescriptreact",
	},

	root_dir = function(bufnr)
		return vim.fs.root(bufnr, { "biome.json", "biome.jsonc" })
	end,
	workspace_required = true,
}
