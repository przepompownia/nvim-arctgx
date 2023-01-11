local api = vim.api

local extension = {}

---@param filetype string
---@param callback fun(winId: int): any
function extension.forEachWindowWithBufFileType(filetype, callback)
  local function runWithBuffer(winId)
    local bufId = api.nvim_win_get_buf(winId)
    if api.nvim_buf_get_option(bufId, 'filetype') ~= filetype then
      return
    end

    callback(winId)
  end

  for _, winId in ipairs(api.nvim_list_wins()) do
    runWithBuffer(winId)
  end
end

return extension
