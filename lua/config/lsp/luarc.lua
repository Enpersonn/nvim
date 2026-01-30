
vim.lsp.config['lua_ls'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_marker = { { '.luarc.json', 'luarc.jsonc' }, '.git' },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}
