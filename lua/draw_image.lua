local M = {}
local api = vim.api
local fn = vim.fn

local create_autocmd = vim.api.nvim_create_autocmd

group = vim.api.nvim_create_augroup("DrawImage", {
	clear = true,
})

local function open_win()
	local buf

	buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")

	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)

	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
		relative = "editor",
		style = "minimal",
		width = win_width,
		height = win_height,
		zindex = 10,
		focusable = false,
		row = row,
		col = col,
	}

	image_path = tostring(fn.getbufinfo("%")[1].name)

	local win = api.nvim_open_win(buf, true, opts)

	job = fn.termopen(vim.o.shell, { detach = 0, cwd = "./" })
end

local function preview_image()
	-- local lines = vim.o.lines
	local height = vim.api.nvim_win_get_height(0)
	local width = vim.api.nvim_win_get_width(0)

	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)

	local x = math.ceil((height - win_height) / 2)
	local y = math.ceil((width - win_width) / 2 + 4)

	local script_path = tostring("~/draw_image/draw_image.sh ")

	fn.chansend(job, api.nvim_replace_termcodes("clear<CR>", true, false, true))

	fn.chansend(
		job,
		api.nvim_replace_termcodes(
			-- script_path .. width .. " " .. height .. " " .. image_path .. "<CR>",
			script_path .. width .. " " .. height .. " " .. y .. " " .. x .. " " .. image_path .. "<CR>",
			true,
			false,
			true
		)
	)
end

M.setup = function()
	create_autocmd("BufReadPost", {
		callback = function()
			open_win()
			preview_image()
		end,
		pattern = "*.jpg",
		group = group,
	})
end

-- Here for future use, for getting path of script

-- local path = debug.getinfo(1).source:match("@?(.*/)")
-- local script_path = tostring(path:gsub("%lua/", "") .. "draw_image.sh")

return M
