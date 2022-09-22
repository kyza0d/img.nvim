local M = {}

local function get_buf_info(bufnr)
  return vim.fn.getbufinfo(bufnr)[1]
end

local viewer = require("imagine.ueberzug").viewer
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
   TODO: Turn job into a opteration
    example:

    job = viewer:request({
      image_path = "path/to/image",
      image_x = 0,
      image_y = 0,
      image_width = 10,
      image_height = 20,
    })

    viewer:start(job)
  ]]

  --[[
   TODO: Redraw function
    example:

    local job = jobs:fetch_job_id()
    viewer:redraw(job)
  ]]

  vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
      -- TODO: Better way of detecting images
      if vim.fn.expand("%:e") == "png" then
        -- Get path of image, and esacpe spaces
        -- TODO: Better way of getting file path
        local path = tostring(vim.fn.getbufinfo("%")[1].name):gsub(" ", "\\ ")

        local width = vim.api.nvim_win_get_width(current_window)
        local height = vim.api.nvim_win_get_height(current_window)

        -- TODO: Get image_dimensions using 'file' command
        -- local image_dimensions = { width = 200, height = 200 }

        -- TODO: Translate image -50% of its width and height ( I have no idea how Im going to do this)
        local x = math.floor(width / 2)
        local y = math.floor(height / 2)

        -- redir @a | echo "This will end up in register a." | redir END

        local job = viewer:request({ "~/plugins/imagine.nvim/ueberzug.sh", path, width, height, x, y })

        viewer:job_start(job)
      end
    end,
    group = image_group,
  })
end

return M
