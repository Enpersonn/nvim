local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config.lua_ls = {
	capabilities = capabilities,
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },

	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					vim.fn.stdpath('config'),
				},
				diagnostics = { globals = { 'vim' } },
				format = { enable = true, },
			},
		},
	},
}
