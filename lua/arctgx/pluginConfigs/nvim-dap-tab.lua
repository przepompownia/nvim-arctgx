local api = vim.api

local session = require 'arctgx.session'
local keymap = require('arctgx.vim.abstractKeymap')

local opts = {silent = true}

keymap.set({'n'}, 'debuggerJumpToUI', function () require('dap-tab').verboseGoToDebugWin() end, opts)
keymap.set({'n'}, 'debuggerCloseUI', function () require('dap-tab').closeDebugWin() end, opts)

local augroup = api.nvim_create_augroup('ArctgxDapTab', {clear = true})
api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DAPClean',
  callback = function () require('dap-tab').closeDebugWin() end,
})

require('arctgx.lazy').setupOnLoad('dap', function ()
  require('dap-tab').setup()
end)

session.appendBeforeSaveHook('dap-tab - close debug window', function () require('dap-tab').closeDebugWin() end)
