local api = vim.api
local keymap = vim.keymap
local base = require('arctgx.base')
local session = require('arctgx.session')
local treeapi = require('nvim-tree.api')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
  hijack_cursor = true,
  actions = {
    change_dir = {
      enable = false,
    },
    open_file = {
      quit_on_open = true,
    },
  },
  on_attach = function (bufnr)
    treeapi.config.mappings.default_on_attach(bufnr)
    local injectNode = require('nvim-tree.utils').inject_node

    vim.keymap.set(
      'n',
      '<TAB>',
      '<C-w>w',
      {buffer = bufnr, noremap = true, desc = 'Jump to the last used window'}
    )
    vim.keymap.set(
      'n',
      '<CR>',
      injectNode(function (node)
        if node.name == '..' or node.type == 'directory' then
          treeapi.node.open.edit()

          return
        end
        treeapi.tree.close()
        base.tabDropPath(node.absolute_path)
      end),
      {buffer = bufnr, noremap = true, desc = 'Open or expand node'}
    )
    vim.keymap.set(
      'n',
      '<Right>',
      function ()
        local node = treeapi.tree.get_node_under_cursor()
        if nil == node or nil == node.nodes then
          return require('arctgx.vim.keymap').feedKeys('<Right>')
        end
        require('nvim-tree.lib').expand_or_collapse(node)
      end,
      {buffer = bufnr, desc = 'Expand directory node or move right'}
    )
    vim.keymap.set(
      'n',
      '<Left>',
      treeapi.node.navigate.parent_close,
      {buffer = bufnr, noremap = true, desc = 'Close directory'}
    )
  end,
  view = {
    signcolumn = 'no',
    -- adaptive_size = true,
  },
  sort = {
    sorter = 'name',
  },
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

local Event = treeapi.events.Event

treeapi.events.subscribe(Event.NodeRenamed, function (data)
  local yes = 'y'
  vim.ui.input({
    prompt = 'Do you want to stage this renaming? > ',
    default = yes,
  }, function (input)
    if input ~= yes then
      return
    end
    vim.system({'git', 'add', '-u', '--', data.old_name})
    vim.system({'git', 'add', '--', data.new_name})
  end)
end)

treeapi.events.subscribe(Event.FileRemoved, function (data)
  local yes = 'y'
  vim.ui.input({
    prompt = 'Do you want to stage this removal? > ',
    default = yes,
  }, function (input)
    if input ~= yes then
      return
    end
    vim.system({'git', 'add', '-u', '--', data.fname})
  end)
end)

local function expandNode()
  local node = treeapi.tree.get_node_under_cursor()
  if node.name == '..' then
    return
  end
  treeapi.node.open.edit(node)
end

local function focusOnFile()
  local bufPath = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0))
  treeapi.tree.open(require('arctgx.git').top(bufPath and vim.fs.dirname(bufPath) or vim.uv.cwd()))
  -- treeapi.tree.toggle_hidden_filter()
  treeapi.live_filter.clear()
  local pathToFocus = bufPath or vim.uv.cwd()
  treeapi.tree.find_file({
    buf = pathToFocus,
  })
  if vim.fn.isdirectory(pathToFocus) == 1 then
    expandNode()
  end
  vim.cmd.normal('zz')
end

keymap.set({'n'}, '<Plug>(ide-tree-focus-current-file)', focusOnFile)

session.appendBeforeSaveHook('Close nvim-tree instances', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'NvimTree'}, function (winId)
    api.nvim_win_close(winId, false)
  end)
end)
