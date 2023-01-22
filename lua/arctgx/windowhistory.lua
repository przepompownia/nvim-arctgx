local WindowHistory = {}

---@type arctgx.History
local history = nil

function WindowHistory.createFromWindowList()
  history = require('arctgx.history'):new(vim.api.nvim_list_wins())
end

function WindowHistory.jumpOnTop()
  vim.api.nvim_set_current_win(history:top())
end

function WindowHistory.jumpBack()
  vim.api.nvim_set_current_win(history:previous())
end

function WindowHistory.getInstance()
  if nil == history then
    WindowHistory.createFromWindowList()
  end

  return history
end

return WindowHistory
