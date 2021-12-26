local actions = require 'telescope.actions'
local transform_mod = require('telescope.actions.mt').transform_mod
local action_set = require 'telescope.actions.set'
local action_layout = require 'telescope.actions.layout'

local customActions = transform_mod({
  tabDrop = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, 'TabDrop')
  end,
})

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-p>'] = actions.cycle_history_next,
        ['<C-n>'] = actions.cycle_history_prev,
        ['<A-Up>'] = actions.preview_scrolling_up,
        ['<A-Down>'] = actions.preview_scrolling_down,
        ['<A-/>'] = action_layout.toggle_preview,
        ['<CR>'] = customActions.tabDrop,
      },
    },
  },
}
