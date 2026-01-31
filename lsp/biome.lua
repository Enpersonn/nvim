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

	root_markers = { "biome.json", "biome.jsonc" },
	workspace_required = true,
}
