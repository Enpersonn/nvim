return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
	confg = function ()
		require("typescript-tools").setup {
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				expose_as_code_action = "all",
				tsserver_max_memory = "auto",
				include_completion_with_insert_text = true,
				code_lens = "off",
			}
		}
	end,
	on_attach = function (client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
	end
}
