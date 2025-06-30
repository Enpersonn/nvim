local lspconfig = require("lspconfig")

-- Get blink.cmp capabilities
local capabilities = require('blink.cmp').get_lsp_capabilities()

if lspconfig.ts_ls then
	lspconfig.ts_ls.setup({
		capabilities = capabilities,
		settings = {
			typescript = {
				format = { enable = true },
			},
			javascript = {
				format = { enable = true },
			},
		},
	})
else
	vim.notify("ts_ls is not available in lspconfig", vim.log.levels.ERROR)
end

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				ceckThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

lspconfig.biome.setup({
	capabilities = capabilities,
	cmd = { "biome", "lsp-proxy" },
	filetypes = { "javascript", "typescript", "json", "tsx", "jsx" },
	root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc", ".git"),
})

lspconfig.jsonls.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buf = args.buf
		local opts = { buffer = buf }
		local map = vim.keymap.set

		vim.lsp.buf.format({ async = false })

		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("n", "gi", vim.lsp.buf.implementation, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		map("n", "[d", vim.diagnostic.goto_prev, opts)
		map("n", "]d", vim.diagnostic.goto_next, opts)
		map("n", "<leader>d", vim.diagnostic.open_float, opts)
	end,
})
