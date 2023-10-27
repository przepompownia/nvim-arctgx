local windowhistory = require 'arctgx.windowhistory'
local api = vim.api

local extension = {}

---@param filetypes table
---@param callback fun(winId: integer): any
function extension.forEachWindowWithBufFileType(filetypes, callback)
  vim.validate({filetypes = {filetypes, {'table'}}})
  local function runWithBuffer(winId)
    if not api.nvim_win_is_valid(winId) then
      return
    end

    local bufId = api.nvim_win_get_buf(winId)
    if not vim.tbl_contains(filetypes, vim.bo[bufId].filetype) then
      return
    end

    callback(winId)
  end

  for _, winId in ipairs(api.nvim_list_wins()) do
    runWithBuffer(winId)
  end
end

local function isPopup(winId)
  if not api.nvim_win_is_valid(winId) then
    return
  end
  return 'popup' == vim.fn.win_gettype(winId)
end

function extension.onWinEnter()
  local winId = api.nvim_get_current_win()
  if isPopup(winId) then
    return
  end
  windowhistory.getInstance():putOnTop(winId)
end

function extension.onWinClosed(winId)
  if isPopup(winId) then
    return
  end

  windowhistory.getInstance():remove(winId)
  windowhistory.jumpOnTop()
end

return extension
