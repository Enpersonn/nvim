local parsers = {
	"lua",
	"javascript",
	"typescript",
	"tsx",
	"vue",
	"c_sharp",
	"razor",
	"html",
	"css",
	"json",
	"xml",
	"sql",
	"markdown",
	"markdown_inline",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		lazy = false,
		config = function()
			local treesitter = require("nvim-treesitter")
			treesitter.install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"lua",
					"javascript",
					"typescript",
					"typescriptreact",
					"vue",
					"cs",
					"csharp",
					"razor",
					"html",
					"css",
					"json",
					"xml",
					"xsd",
					"xslt",
					"svg",
					"sql",
					"markdown",
					"pandoc",
				},
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
}
