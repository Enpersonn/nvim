return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "Format current file",
			},
		},
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				lua = { "stylua" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				local autoformat_filetypes = {
					javascript = true,
					javascriptreact = true,
					typescript = true,
					typescriptreact = true,
					vue = true,
					css = true,
					scss = true,
					html = true,
					json = true,
					jsonc = true,
					lua = true,
				}

				if autoformat_filetypes[vim.bo[bufnr].filetype] then
					return { timeout_ms = 1000, lsp_format = "fallback" }
				end
			end,
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, { bang = true, desc = "Disable format-on-save" })
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, { desc = "Enable format-on-save" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint" },
				javascriptreact = { "eslint" },
				typescript = { "eslint" },
				typescriptreact = { "eslint" },
				vue = { "eslint" },
			}

			lint.linters.eslint.cmd = function()
				local root = vim.fs.root(0, { "eslint.config.js", "eslint.config.mjs", ".eslintrc.js", "package.json" })
				local local_eslint = root and (root .. "/node_modules/.bin/eslint")
				if local_eslint and vim.fn.executable(local_eslint) == 1 then
					return local_eslint
				end
				return "eslint"
			end

			local lint_group = vim.api.nvim_create_augroup("UserLint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_group,
				callback = function(args)
					local root = vim.fs.root(args.buf, { "eslint.config.js", "eslint.config.mjs", ".eslintrc.js", "package.json" })
					lint.try_lint(nil, { cwd = root or vim.fn.getcwd() })
				end,
			})
		end,
	},
}
