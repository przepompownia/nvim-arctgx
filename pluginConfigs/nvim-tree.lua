local api = vim.api
local keymap = require('vim.keymap')
local base = require('arctgx.base')
local arctgxKeymap = require('arctgx.vim.keymap')
local session = require('arctgx.session')

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
    local injectNode = require('nvim-tree.utils').inject_node

    vim.keymap.set(
      'n',
      '<CR>',
      injectNode(function(node)
        if nil == node.nodes then
          require('nvim-tree.api').tree.close()
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
        local node = require('nvim-tree.api').tree.get_node_under_cursor()
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
      require('nvim-tree.api').node.navigate.parent_close,
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
  filters = {
    dotfiles = false,
  },
  git = {
    ignore = false,
  },
})

local function focusOnFile()
  local treeapi = require('nvim-tree.api')
  local bufName = vim.api.nvim_buf_get_name(0)
  treeapi.tree.open(require('arctgx.git').top(vim.fs.dirname(bufName)))
  -- treeapi.tree.toggle_hidden_filter()
  treeapi.live_filter.clear()
  treeapi.tree.find_file(bufName)
end

-- @todo
-- cursorline
-- shell on node dir

keymap.set({'n'}, '<Plug>(ide-tree-focus-current-file)', focusOnFile)

session.appendBeforeSaveHook('Close nvim-tree instances', function ()
  require('arctgx.window').forEachWindowWithBufFileType('NvimTree', function (winId)
    api.nvim_win_close(winId, false)
  end)
end)
