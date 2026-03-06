local tsSelectKeymaps = {
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
  ['ai'] = '@conditional.outer',
  ['ii'] = '@conditional.inner',
}

local api = vim.api

local function setKeymaps(buf)
  local map = function (modes, lhs, rhs)
    vim.keymap.set(modes, lhs, rhs, {buffer = buf})
  end
  for input, capture in pairs(tsSelectKeymaps) do
    map({'x', 'o'}, input, function ()
      require 'nvim-treesitter-textobjects.select'.select_textobject(capture, 'textobjects')
    end)
  end

  local move = require('nvim-treesitter-textobjects.move')

  map({'n', 'x', 'o'}, '[C', function ()
    move.goto_previous_start('@comment.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, '[[', function ()
    move.goto_previous_start('@function.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, '[m', function ()
    move.goto_previous_start('@class.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, ']C', function ()
    move.goto_next_start('@comment.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, ']]', function ()
    move.goto_next_start('@function.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, ']m', function ()
    move.goto_next_start('@class.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, '[]', function ()
    move.goto_previous_end('@function.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, '[M', function ()
    move.goto_previous_end('@class.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, '][', function ()
    move.goto_next_end('@function.outer', 'textobjects')
  end)
  map({'n', 'x', 'o'}, ']M', function ()
    move.goto_next_end('@class.outer', 'textobjects')
  end)

  map('n', '<leader>a', function ()
    require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
  end)
  map('n', '<leader>A', function ()
    require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
  end)
end

vim.api.nvim_create_autocmd('FileType', {
  group = api.nvim_create_augroup('arctgx.treesitter.textobjects', {clear = true}),
  pattern = require('arctgx.treesitter').fileTypes(),
  callback = function (ev)
    setKeymaps(ev.buf)
  end,
})

require('nvim-treesitter-textobjects').setup {
  textobjects = {
    select = {
      lookahead = true,
      selection_modes = {
        ['@function.outer'] = 'V',
        ['@class.outer'] = 'V',
      },
      -- include_surrounding_whitespace = true,
    },
    move = {
      set_jumps = true,
    },
    swap = {
    },
  },
}
