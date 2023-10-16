local tsj = require('treesj')

local langs = {}

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 120,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
})
vim.keymap.set({'n'}, '<Plug>(ide-toggle-split-join-lines-at-cursor)', tsj.toggle, {})
vim.keymap.set({'n'}, '<Plug>(ide-toggle-split-lines-at-cursor)', tsj.split, {})
vim.keymap.set({'n'}, '<Plug>(ide-toggle-join-lines-at-cursor)', tsj.join, {})
