local api = vim.api

local WindowHistory = {}

---@type arctgx.History
local history = nil

function WindowHistory.createFromWindowList()
  history = require('arctgx.history'):new(api.nvim_list_wins())
end

---comment
---@param callback function:integer
---@return unknown
local function findValidId(callback)
  local winId = callback()
  while nil ~= winId and not api.nvim_win_is_valid(winId) do
    history:remove(winId)
    winId = callback()
  end

  return winId
end

function WindowHistory.jumpOnTop()
  local top = findValidId(function() history:top() end)
  if nil == top then
    return
  end
  api.nvim_set_current_win(history:top())
end

function WindowHistory.jumpBack()
  api.nvim_set_current_win(history:previous())
end

function WindowHistory.getInstance()
  if nil == history then
    WindowHistory.createFromWindowList()
  end

  return history
end

function WindowHistory.debug()
  local historyWithNames = {}
  for _, winId in ipairs(history) do
    historyWithNames[winId] = api.nvim_buf_get_name(api.nvim_win_get_buf(winId))
  end

  return historyWithNames
end

return WindowHistory
local api = vim.api

local WindowHistory = {}

---@type arctgx.History
local history = nil

function WindowHistory.createFromWindowList()
  history = require('arctgx.history'):new(api.nvim_list_wins())
end

---comment
---@param callback function:integer
---@return unknown
local function findValidId(callback)
  local winId = callback()
  while nil ~= winId and not api.nvim_win_is_valid(winId) do
    history:remove(winId)
    winId = callback()
  end

  return winId
end

function WindowHistory.jumpOnTop()
  local top = findValidId(function() history:top() end)
  if nil == top then
    return
  end
  api.nvim_set_current_win(history:top())
end

function WindowHistory.jumpBack()
  api.nvim_set_current_win(history:previous())
end

function WindowHistory.getInstance()
  if nil == history then
    WindowHistory.createFromWindowList()
  end

  return history
end

function WindowHistory.debug()
  local historyWithNames = {}
  for _, winId in ipairs(history) do
    historyWithNames[winId] = api.nvim_buf_get_name(api.nvim_win_get_buf(winId))
  end

  return historyWithNames
end

return WindowHistory
