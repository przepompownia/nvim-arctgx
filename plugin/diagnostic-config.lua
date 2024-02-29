vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  float = {
    border = 'rounded',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '󰀪',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  severity_sort = true,
})

local keymap = require('arctgx.vim.abstractKeymap')
keymap.set('n', 'diagnosticOpenFloat', vim.diagnostic.open_float, {})
keymap.set('n', 'diagnosticGotoPrevious', vim.diagnostic.goto_prev, {})
keymap.set('n', 'diagnosticGotoNext', vim.diagnostic.goto_next, {})
keymap.set('n', 'diagnosticSetLocList', vim.diagnostic.setloclist, {})
