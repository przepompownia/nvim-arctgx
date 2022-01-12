local keymap = require('vim.keymap')
require('litee.symboltree').setup({
  on_open = 'panel',
  map_resize_keys = false,
  keymaps = {
    hide = '<Esc>',
    expand = '<Right>',
    collapse = '<Left>',
    collapse_all = 'zM',
    jump = '<CR>',
    jump_split = 's',
    jump_vsplit = 'v',
    jump_tab = 't',
    hover = 'i',
    details = 'd',
    close = 'X',
    close_panel_pop_out = 'H',
    help = '?',
  },
})

keymap.set({'n'}, '<Plug>(ide-outline)', vim.lsp.buf.document_symbol)
