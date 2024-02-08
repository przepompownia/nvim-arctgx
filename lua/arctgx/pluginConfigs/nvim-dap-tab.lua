local dapTab = require 'dap-tab'
local session = require 'arctgx.session'
local api = vim.api
local keymap = require('arctgx.vim.abstractKeymap')

local opts = {silent = true}

keymap.set({'n'}, 'debuggerJumpToUI', dapTab.verboseGoToDebugWin, opts)
keymap.set({'n'}, 'debuggerCloseUI', dapTab.closeDebugWin, opts)

local augroup = api.nvim_create_augroup('ArctgxDapTab', {clear = true})
api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DAPClean',
  callback = dapTab.closeDebugWin,
})

dapTab.setup()

session.appendBeforeSaveHook('dap-tab - close debug window', dapTab.closeDebugWin)
