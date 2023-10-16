local dapTab = require 'dap-tab'
local session = require 'arctgx.session'
local api = vim.api

local opts = {silent = true, noremap = true}

vim.keymap.set({'n'}, '<Plug>(ide-debugger-go-to-view)', dapTab.verboseGoToDebugWin, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-close-view)', dapTab.closeDebugWin, opts)

local augroup = api.nvim_create_augroup('ArctgxDapTab', {clear = true})
api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DAPClean',
  callback = dapTab.closeDebugWin,
})

dapTab.setup()

session.appendBeforeSaveHook('dap-tab - close debug window', dapTab.closeDebugWin)
