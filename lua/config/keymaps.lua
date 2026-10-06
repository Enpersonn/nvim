local map = vim.keymap.set

map("n", "<S-CR>", function()
	return "<Esc>o"
end, { expr = true, desc = "Insert new line below" })

map("n", "<C-S-CR>", function()
	return "<Esc>O"
end, { expr = true, desc = "Insert new line above" })
