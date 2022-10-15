local keymap = require('vim.keymap')
local treeapi = require('nvim-tree.api')
local git = require('arctgx.git')

require('nvim-tree').setup({
  sort_by = 'case_insensitive',
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        {
          key = 'u',
          action = 'dir_up',
        },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

local function focusOnFile()
  treeapi.tree.toggle(true, false, git.top(vim.fs.dirname(vim.api.nvim_buf_get_name(0))))
end

keymap.set({'n'}, '<Plug>(ide-tree-focus-current-file', focusOnFile)
