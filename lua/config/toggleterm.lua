require("toggleterm").setup {
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	direction = "horizontal",
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	start_in_insert = true,
	shading_factor = 2,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	persist_mode = false,
}
