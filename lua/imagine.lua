local M = {}

local function get_buf_infofunction(bufnr)
	return vim.fn.getbufinfo(bufnr)[1]
end

M.setup = function()
	-- TODO: Display a floating window [Done]

	local api = vim.api
	local buf, win

	local function open_window()
		buf = api.nvim_create_buf(false, true) -- create new emtpy buffer

		api.nvim_buf_set_lines(buf, 0, 2, false, { "header" })
		api.nvim_buf_set_lines(buf, 1, -1, false, { "sub" })

		vim.cmd([[
      hi WhidHeader guibg=blue
      hi WhidSubHeader guibg=purple
    ]])

		api.nvim_buf_add_highlight(buf, -1, "WhidHeader", 0, 0, -1)
		api.nvim_buf_add_highlight(buf, -1, "WhidSubHeader", 1, 0, -1)

		api.nvim_buf_set_option(buf, "modifiable", false)

		-- get dimensions

		local win_width = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win()) - 2
		local win_height = vim.api.nvim_win_get_height(vim.api.nvim_get_current_win()) - 2

		local row = 1
		local col = 1

		-- set some options
		local opts = {
			style = "minimal",
			relative = "editor",
			border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
			focusable = false,
			width = win_width,
			height = win_height,
			row = row,
			col = col,
		}

		-- and finally create it with buffer attached
		win = api.nvim_open_win(buf, false, opts)
	end

	local image_group = vim.api.nvim_create_augroup("imagine.nvim", { clear = true })

	vim.api.nvim_create_autocmd("BufReadPost", {
		callback = function()
			-- TODO: Better way of detecting images
			if vim.fn.expand("%:e") == "png" then
				open_window()
			end
		end,
		group = image_group,
	})
end

return M
