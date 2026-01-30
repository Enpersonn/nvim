
vim.lsp.config['luals'] = {
	cmd = { 'lua-language-server' },
	filetype = { 'lua' },
	root_markers = { { '.luarc.json', '.luarc.jsonc'}, '.git' },

	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			}
		}
	}
}
