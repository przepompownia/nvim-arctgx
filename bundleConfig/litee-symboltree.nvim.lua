local keymap = require('vim.keymap')
require('litee.symboltree').setup({
  on_open = 'panel',
  map_resize_keys = false,
})

keymap.set({'n'}, '<Plug>(ide-outline)', vim.lsp.buf.document_symbol)
