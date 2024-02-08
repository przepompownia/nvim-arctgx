local tsj = require('treesj')
local keymap = require('arctgx.vim.abstractKeymap')

local langs = {
  php_only = require('treesj.langs.utils').merge_preset(require('treesj.langs.php'), {}),
}

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 120,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
})

keymap.set({'n'}, 'toggleSplitJoinLinesAtCursor', tsj.toggle, {})
keymap.set({'n'}, 'splitLinesAtCursor', tsj.split, {})
keymap.set({'n'}, 'joinLinesAtCursor', tsj.join, {})
