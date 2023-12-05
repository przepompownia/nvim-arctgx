local keymap = require('arctgx.vim.abstractKeymap')

local peekDefMap = {}
peekDefMap[keymap.firstLhs('langPeekDefinition')] = '@function.outer'

require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      lookahead = true,

      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['al'] = '@block.outer',
        ['il'] = '@block.inner',
        ['as'] = '@statement.outer',
        ['is'] = '@statement.inner',
        ['aa'] = '@assignment.outer',
        ['ia'] = '@assignment.inner',
        ['ac'] = '@call.outer',
        ['ic'] = '@call.inner',
        ['aO'] = '@comment.outer',
        ['iO'] = '@comment.inner',
        ['ap'] = '@parameter.outer',
        ['ip'] = '@parameter.inner',
      },
      selection_modes = {
        ['@function.outer'] = 'V',
        ['@class.outer'] = 'V',
      },
      -- include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']]'] = '@function.outer',
        [']m'] = '@class.outer',
      },
      goto_next_end = {
        [']['] = '@function.outer',
        [']M'] = '@class.outer',
      },
      goto_previous_start = {
        ['[['] = '@function.outer',
        ['[m'] = '@class.outer',
      },
      goto_previous_end = {
        ['[]'] = '@function.outer',
        ['[M'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<Leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<Leader>A'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = peekDefMap,
    },
  },
}
