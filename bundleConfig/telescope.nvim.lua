local actions = require 'telescope.actions'
local transform_mod = require('telescope.actions.mt').transform_mod
local action_set = require "telescope.actions.set"

local customActions = transform_mod({
  tabDrop = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, "TabDrop")
  end,
})

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-p>'] = actions.cycle_history_next,
        ['<C-n>'] = actions.cycle_history_prev,
        ['<CR>'] = customActions.tabDrop,
      },
    },
  },
}
