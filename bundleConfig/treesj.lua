local tsj = require('treesj')

local langs = {}

tsj.setup({
  use_default_keymaps = true,
  check_syntax_error = true,
  max_join_length = 120,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
})
