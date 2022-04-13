local keymap = require 'vim.keymap'
local trevj = require('trevj')

keymap.set({'n'}, '<Plug>(ide-revj-at-cursor)', trevj.format_at_cursor, {})

local make_default_opts = function()
  return {
    final_separator = ',',
    final_end_line = true,
  }
end


local make_no_final_sep_opts = function()
  return {
    final_separator = false,
    final_end_line = true,
  }
end

trevj.setup({
  containers = {
    -- php = {
    --   array_creation_expression = make_default_opts(),
    --   list_literal = make_default_opts(),
    --   formal_parameters = make_default_opts(),
    --   arguments = make_default_opts(),
    -- },
  },
})
