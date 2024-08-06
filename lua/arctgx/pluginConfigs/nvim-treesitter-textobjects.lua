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
}

for input, capture in pairs(tsSelectKeymaps) do
  vim.keymap.set({'x', 'o'}, input, function ()
    require 'nvim-treesitter-textobjects.select'.select_textobject(capture, 'textobjects')
  end)
end

vim.keymap.set({'n', 'x', 'o'}, '[[', function ()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, '[m', function ()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, ']]', function ()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, ']m', function ()
  require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, '[]', function ()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, '[M', function ()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, '][', function ()
  require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
end)
vim.keymap.set({'n', 'x', 'o'}, ']M', function ()
  require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
end)

vim.keymap.set('n', '<leader>a', function ()
  require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')()
end)
vim.keymap.set('n', '<leader>A', function ()
  require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')()
end)

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
