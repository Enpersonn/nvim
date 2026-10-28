local M = {}

local defaults = {
	max_bytes = 100 * 1024,
	max_lines = 2000,
}

local function append_chunk(target, lines)
	if #target == 0 then
		vim.list_extend(target, lines)
		return
	end

	-- nvim_paste() chunks can split in the middle of a line. The first line of
	-- the next chunk therefore continues the final line of the previous chunk.
	target[#target] = target[#target] .. (lines[1] or "")
	for index = 2, #lines do
		target[#target + 1] = lines[index]
	end
end

local function paste_size(lines)
	local bytes = math.max(#lines - 1, 0) -- Account for line breaks.
	for _, line in ipairs(lines) do
		bytes = bytes + #line
	end
	return bytes, #lines
end

local function format_bytes(bytes)
	if bytes >= 1024 * 1024 then
		return string.format("%.1f MiB", bytes / (1024 * 1024))
	end
	return string.format("%.1f KiB", bytes / 1024)
end

function M.setup(opts)
	opts = vim.tbl_extend("force", defaults, opts or {})

	local native_paste = vim.paste
	local streamed_lines

	local function allowed(lines)
		local bytes, line_count = paste_size(lines)
		if bytes <= opts.max_bytes and line_count <= opts.max_lines then
			return true
		end

		local message = string.format(
			"Paste %s across %d lines?\nLarge edits can temporarily block Neovim.",
			format_bytes(bytes),
			line_count
		)
		if vim.fn.confirm(message, "&Paste anyway\n&Cancel", 2, "Question") == 1 then
			return true
		end

		vim.notify("Large paste cancelled", vim.log.levels.INFO)
		return false
	end

	vim.paste = function(lines, phase)
		if phase == -1 then
			return allowed(lines) and native_paste(lines, phase) or false
		end

		if phase == 1 then
			streamed_lines = {}
		end

		-- Buffer streamed terminal paste before touching the current buffer. This
		-- allows an oversized accidental paste to be rejected without needing an
		-- expensive undo after Treesitter, LSP, and other listeners have run.
		streamed_lines = streamed_lines or {}
		append_chunk(streamed_lines, lines)

		if phase ~= 3 then
			return true
		end

		local complete_paste = streamed_lines
		streamed_lines = nil
		return allowed(complete_paste) and native_paste(complete_paste, -1) or false
	end

	local function guarded_put(key)
		return function()
			local register_name = vim.v.register
			local clipboard = "," .. vim.o.clipboard .. ","
			if register_name == '"' and clipboard:find(",unnamedplus,", 1, true) then
				register_name = "+"
			elseif register_name == '"' and clipboard:find(",unnamed,", 1, true) then
				register_name = "*"
			end

			local register = vim.fn.getreginfo(register_name)
			return allowed(register.regcontents or {}) and key or "<Ignore>"
		end
	end

	for _, key in ipairs({ "p", "P" }) do
		vim.keymap.set({ "n", "x" }, key, guarded_put(key), {
			expr = true,
			desc = "Paste with large-paste guard",
		})
	end
end

return M
