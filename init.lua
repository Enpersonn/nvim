require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("nvim-treesitter.install").compilers = ("cl")

vim.lsp.enable('biome')
vim.lsp.enable('lua_ls')

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.null_ls")
		require("config.keymaps")
		require("config.typescript-tools")
		require("config.copilot")
		require("config.fyler")
	end,
})
