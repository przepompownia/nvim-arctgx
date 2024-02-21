local api = vim.api
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
    remove_file = {
      close_window = false,
    },
  },
  on_attach = function (bufnr)
    treeapi.config.mappings.default_on_attach(bufnr)

    vim.keymap.set(
      'n',
      '<TAB>',
      '<C-w>w',
      {buffer = bufnr, desc = 'Jump to the last used window'}
    )
    vim.keymap.set(
      'n',
      '<Right>',
      function ()
        local node = treeapi.tree.get_node_under_cursor()
        if nil == node or nil == node.nodes then
          return api.nvim_feedkeys(vim.keycode('<Right>'), 'n', false)
        end
        require('nvim-tree.lib').expand_or_collapse(node)
      end,
      {buffer = bufnr, desc = 'Expand directory node or move right'}
    )
    vim.keymap.set(
      'n',
      '<Left>',
      treeapi.node.navigate.parent_close,
      {buffer = bufnr, desc = 'Close directory'}
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
    vim.notify(('renamed from %s to %s'):format(data.old_name, data.new_name), vim.log.levels.INFO, {title = 'NvimTree'})
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
  local bufPath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
  local realParent = vim.iter(vim.fs.parents(bufPath)):find(function (path)
    return vim.uv.fs_realpath(path) and path ~= '/'
  end) or vim.uv.cwd()
  treeapi.tree.open(require('git-utils.git').top(realParent))
  -- treeapi.tree.toggle_hidden_filter()
  treeapi.live_filter.clear()
  local pathToFocus = vim.uv.fs_realpath(bufPath) or realParent

  treeapi.tree.find_file({
    buf = pathToFocus,
  })
  if vim.fn.isdirectory(pathToFocus) == 1 then
    expandNode()
  end
  vim.cmd.normal('zz')
end

require('arctgx.vim.abstractKeymap').set({'n'}, 'fileTreeFocus', focusOnFile)

session.appendBeforeSaveHook('Close nvim-tree instances', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'NvimTree'}, function (winId)
    api.nvim_win_close(winId, false)
  end)
end)
