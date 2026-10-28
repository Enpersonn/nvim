vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- All configured plugins are Lua-native, so the legacy remote providers are unnecessary.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.confirm = true

local options_group = vim.api.nvim_create_augroup("UserOptions", { clear = true })

-- Dashboard-style buffers change window-local options. Restore the defaults when
-- a normal file is opened in the same window.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	group = options_group,
	callback = function()
		if vim.bo.buftype == "" then
			vim.wo.number = true
			vim.wo.relativenumber = true
			vim.wo.signcolumn = "yes"
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = options_group,
	pattern = { "cs", "razor" },
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = options_group,
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})
