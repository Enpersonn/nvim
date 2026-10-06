local map = vim.keymap.set

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	float = {
		border = "rounded",
		source = true,
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
local vue_ls_bin = vim.uv.fs_realpath(vim.fn.exepath("vue-language-server"))
local vue_language_server_path = vue_ls_bin and vim.fs.dirname(vim.fs.dirname(vue_ls_bin)) or nil

vim.lsp.config("vue_ls", {
	capabilities = capabilities,
})

vim.lsp.config("vtsls", {
	capabilities = capabilities,
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserver = {
				globalPlugins = vue_language_server_path and {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
						configNamespace = "typescript",
					},
				} or {},
			},
		},
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		javascript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
})

vim.lsp.enable({ "biome", "lua_ls", "vtsls", "vue_ls" })

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { buffer = args.buf }

		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end

		map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: Definition" }))
		map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: References" }))
		map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP: Implementation" }))
		map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover" }))
		map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: Rename" }))
		map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: Code action" }))
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, vim.tbl_extend("force", opts, { desc = "Diagnostic: Previous" }))
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, vim.tbl_extend("force", opts, { desc = "Diagnostic: Next" }))
		map("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Diagnostic: Open" }))
	end,
})
