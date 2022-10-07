local M = {}

local function get_buf_info(bufnr)
  return vim.fn.getbufinfo(bufnr)[1]
end

-- TODO: Add support for svg images, I can convert svg images to pngs with ImageMagick
-- magick mogrify -size 512x512 -format png image.svg

local ueberzug = require("imagine.ueberzug").ueberzug
local jobs = require("imagine.ueberzug").jobs

local current_window = 0

M.setup = function()
  -- TODO: Get information of each open window
  -- TODO: Center ueberzug image

  local image_group = vim.api.nvim_create_augroup("imagine.nvim", { clear = true })

  vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
      -- Remove image from buffers with running jobs
      if vim.b.job_id then
        local job = jobs:fetch_job_id()
        jobs:kill(job)
      end
    end,
    group = image_group,
  })

  --[[
   TODO: Turn job into a operation
    example:

    job = ueberzug:register({
      position = "center",
      path = "path/to/image",
      scaler = "crop",
      height = 20,
      width = 10,
    })

    viewer:start(job)
  ]]

  --[[
   TODO: Redraw function
    example:

    local job = jobs:fetch_job_id()
    viewer:redraw(job)
  ]]

  vim.filetype.add({
    extension = {
      png = "png",
      jpg = "jpg",
      jpeg = "jpeg",
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "png,jpg,jpeg",
    callback = function()
      -- TODO: Better way of getting file path
      local path = tostring(vim.fn.getbufinfo("%")[1].name):gsub(" ", "\\ ")

      local width = vim.api.nvim_win_get_width(current_window)
      local height = vim.api.nvim_win_get_height(current_window)

      -- TODO: Center image
      -- TODO: Translate image -50% of its width and height ( I have no idea how I'm going to do this )
      --[[
            With ImageMagick let's me manipulate the image in all sorts of ways,
            perhaps scale I can scale the image in a way where the size is always consistent and will
            match the viewport of the terminal
        ]]
      local column_px = 15
      local row_px = 60

      local img_dimensions = vim.fn.systemlist('magick identify -format "%w\n%h" ' .. path)

      local img_width = img_dimensions[1]
      local img_height = img_dimensions[2]

      local w_image_dimensions_off = math.ceil(img_width / column_px)
      local h_image_dimensions_off = math.ceil(img_height / row_px)

      local x = math.ceil(width / 2) - w_image_dimensions_off
      local y = math.ceil(height / 2) - h_image_dimensions_off

      local job = ueberzug:request({ "~/plugins/imagine.nvim/ueberzug.sh", path, width, height, x, y })

      -- TODO: Draw imagine in floating window
      ueberzug:job_start(job)
    end,
    group = image_group,
  })
end

-- local term = vim.api.nvim_open_term(0, {})
--
-- local function send_output(_, data, _)
--   for _, d in ipairs(data) do
--     vim.api.nvim_chan_send(term, d .. "\r\n")
--   end
-- end
--
-- vim.fn.jobstart(
--   [[kitty +kitten icat --place 50x50@75x5 ~/plugins/imagine.nvim/images/200\ x\ 200.png]],
--   { on_stdout = send_output, stdout_buffered = true }
-- )

return M
