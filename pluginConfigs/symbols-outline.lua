local keymap = require('vim.keymap')
local so = require('symbols-outline')

vim.g.symbols_outline = {
  width = 50,
  auto_preview = false,
  symbol_blacklist = {
    'Variable',
  },
  keymaps = {
    goto_location = {'<CR>', '<2-LeftMouse>'},
  },
}

keymap.set({'n'}, '<Plug>(ide-outline)', so.toggle_outline)

vim.api.nvim_exec([[
  hi FocusedSymbol gui=italic guibg=#dddddd
  ]], false)
