local keymap = require('vim.keymap')
local treeapi = require('nvim-tree.api')
local git = require('arctgx.git')
local base = require('arctgx.base')
local ntApi = require('nvim-tree.api')
local arctgxKeymap = require('arctgx.vim.keymap')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
  hijack_cursor = true,
  remove_keymaps = {'<Tab>'},
  actions = {
    change_dir = {
      enable = false,
    },
    open_file = {
      quit_on_open = true,
    },
  },
  on_attach = function(bufnr)
    -- vim.wo.cursorline = 1
    local inject_node = require('nvim-tree.utils').inject_node

    vim.keymap.set(
      'n',
      '<CR>',
      inject_node(function(node)
        if nil == node.nodes then
          treeapi.tree.close()
          base.tab_drop_path(node.absolute_path)
          return
        end
        require('nvim-tree.lib').expand_or_collapse(node)
      end),
      {buffer = bufnr, noremap = true}
    )
    vim.keymap.set(
      'n',
      '<Right>',
      function ()
        local node = require('nvim-tree.lib').get_node_at_cursor()
        if nil == node.nodes then
          return arctgxKeymap.feedKeys('<Right>')
        end
        require('nvim-tree.lib').expand_or_collapse(node)
      end,
      {buffer = bufnr}
    )
    vim.keymap.set(
      'n',
      '<Left>',
      ntApi.node.navigate.parent_close,
      {buffer = bufnr, noremap = true}
    )
  end,
  view = {
    signcolumn = 'no',
    -- adaptive_size = true,
  },
  sort_by = 'case_insensitive',
  renderer = {
    full_name = true,
    group_empty = true,
    icons = {
      git_placement = 'after',
      glyphs = {
        default = '',
        symlink = '',
        bookmark = '',
        folder = {
          arrow_closed = '▶',
          arrow_open = '▼',
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
      },
    },
  },
  filters = {dotfiles = true},
})

local function focusOnFile()
  treeapi.tree.toggle(true, false, git.top(vim.fs.dirname(vim.api.nvim_buf_get_name(0))))
end

-- @todo
-- cursorline
-- shell on node dir

keymap.set({'n'}, '<Plug>(ide-tree-focus-current-file', focusOnFile)
