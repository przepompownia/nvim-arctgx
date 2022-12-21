local keymap = require 'vim.keymap'
local dapTab = require 'dap-tab'

local opts = {silent = true, noremap = true}

keymap.set({'n'}, '<Plug>(ide-debugger-go-to-view)', dapTab.verboseGoToDebugWin, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-close-view)', dapTab.closeDebugWin, opts)
