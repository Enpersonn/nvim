return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "▁" },
			topdelete = { text = "▔" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = { follow_files = true },
		attach_to_untracked = true,
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 500,
			virt_text_pos = "eol",
			ignore_whitespace = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, "Git: Next hunk")
			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, "Git: Previous hunk")

			map("n", "<leader>hs", gitsigns.stage_hunk, "Git: Stage hunk")
			map("n", "<leader>hr", gitsigns.reset_hunk, "Git: Reset hunk")
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Git: Stage selected hunks")
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Git: Reset selected hunks")
			map("n", "<leader>hS", gitsigns.stage_buffer, "Git: Stage buffer")
			map("n", "<leader>hR", function()
				if vim.fn.confirm("Reset all changes in this buffer?", "&Yes\n&No", 2) == 1 then
					gitsigns.reset_buffer()
				end
			end, "Git: Reset buffer")
			map("n", "<leader>hp", gitsigns.preview_hunk, "Git: Preview hunk")
			map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Git: Preview hunk inline")
			map("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, "Git: Blame line")
			map("n", "<leader>hd", gitsigns.diffthis, "Git: Diff against index")
			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, "Git: Diff against previous commit")
			map("n", "<leader>hq", gitsigns.setqflist, "Git: Buffer hunks in quickfix")
			map("n", "<leader>hQ", function()
				gitsigns.setqflist("all")
			end, "Git: Repository hunks in quickfix")

			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Git: Toggle line blame")
			map("n", "<leader>tw", gitsigns.toggle_word_diff, "Git: Toggle word diff")
			map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git: Select hunk")
		end,
	},
}
