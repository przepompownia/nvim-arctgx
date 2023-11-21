local windowhistory = require 'arctgx.windowhistory'
local api = vim.api

local extension = {}

---@param filetypes table
---@param callback fun(winId: integer): any
function extension.forEachWindowWithBufFileType(filetypes, callback)
  vim.validate({filetypes = {filetypes, {'table'}}})
  vim.iter(api.nvim_list_wins())
    :filter(function (winId)
      return api.nvim_win_is_valid(winId)
        and vim.tbl_contains(filetypes, vim.bo[api.nvim_win_get_buf(winId)].filetype)
    end)
    :each(callback)
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
