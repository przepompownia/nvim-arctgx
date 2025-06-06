vim.diagnostic.config({
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
keymap.set('n', 'diagnosticSetLocList', vim.diagnostic.setloclist, {})
