local windowhistory = require 'arctgx.windowhistory'
local window        = require 'arctgx.window'
local api = vim.api

local augroup = api.nvim_create_augroup('WindowHistory', {clear = true})
api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  callback = windowhistory.createFromWindowList,
})
api.nvim_create_autocmd('WinEnter', {
  group = augroup,
  callback = window.onWinEnter,
  nested = true,
})
api.nvim_create_autocmd('WinClosed', {
  group = augroup,
  callback = function (params)
    window.onWinClosed(tonumber(params.file))
  end,
  nested = true,
})

vim.keymap.set('n', '<Plug>(ide-close-popup)', window.closePopupForTab)
