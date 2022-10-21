local keymap = require('vim.keymap')
local treeapi = require('nvim-tree.api')
local git = require('arctgx.git')
local base = require('arctgx.base')
local ntApi = require('nvim-tree.api')

require('nvim-tree').setup({
  on_attach = function(bufnr)
    print(bufnr)
    -- vim.wo.cursorline = 1
    local inject_node = require('nvim-tree.utils').inject_node

    vim.keymap.set(
      'n',
      '<CR>',
      inject_node(function(node)
        if 1 == vim.fn.isdirectory(node.absolute_path) then
          base.tab_drop_path(node.absolute_path)
        end
      end),
      {buffer = bufnr, noremap = true}
    )
    vim.keymap.set(
      'n',
      '<Right>',
      inject_node(function(node)
        if node.nodes then
          require('nvim-tree.lib').expand_or_collapse(node)
        end
      end),
      {buffer = bufnr, noremap = true}
    )
    vim.keymap.set(
      'n',
      '<Left>',
      ntApi.node.navigate.parent_close,
      {buffer = bufnr, noremap = true}
    )
  end,
  sort_by = 'case_insensitive',
  view = {
    mappings = {
      list = {
        {
          key = '<Tab>',
          action = '',
        },
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        default = '●',
        symlink = '',
        bookmark = '',
        folder = {
          arrow_closed = '▶',
          arrow_open = '▼',
          default = '',
          open = ' ',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
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
-- mappings
-- icons
-- cursorline
-- line hover

keymap.set({'n'}, '<Plug>(ide-tree-focus-current-file', focusOnFile)
