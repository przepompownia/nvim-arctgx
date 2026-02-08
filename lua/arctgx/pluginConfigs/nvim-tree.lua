local api = vim.api
local session = require('arctgx.session')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function isFileTracked(path)
  local git = require('arctgx.git')
  local gitDir = git.top(vim.fs.dirname(path))

  return gitDir and git.isTracked(path, vim.fs.joinpath(gitDir, '.git'), gitDir)
end

api.nvim_create_autocmd('User', {
  pattern = 'NvimTreeSetup',
  callback = function ()
    local treeapi = require('nvim-tree.api')
    local Event = treeapi.events.Event
    --- @param obj vim.SystemCompleted
    local function onExit(obj)
      if obj.code > 0 then
        vim.notify(
          obj.stderr,
          vim.log.levels.WARN
        )
      end
    end

    treeapi.events.subscribe(Event.NodeRenamed, function (data)
      if not isFileTracked(data.old_name) then
        return
      end
      local yes = 'y'
      vim.ui.input({
        prompt = 'Do you want to stage this renaming? > ',
        default = yes,
      }, function (input)
        if input ~= yes then
          return
        end
        vim.system({'git', 'add', '-u', '--', data.old_name}, {}, onExit)
        vim.system({'git', 'add', '--', data.new_name}, {}, onExit)
        vim.notify(
          ('renamed from %s to %s'):format(data.old_name, data.new_name),
          vim.log.levels.INFO
        )
      end)
    end)

    treeapi.events.subscribe(Event.FileRemoved, function (data)
      if not isFileTracked(data.fname) then
        return
      end
      local yes = 'y'
      vim.ui.input({
        prompt = 'Do you want to stage this removal? > ',
        default = yes,
      }, function (input)
        if input ~= yes then
          return
        end
        vim.system({'git', 'add', '-u', '--', data.fname}, {}, onExit)
      end)
    end)
  end,
})

local function setup()
  require('nvim-tree').setup({
    hijack_cursor = true,
    actions = {
      change_dir = {
        enable = false,
      },
      open_file = {
        quit_on_open = true,
        window_picker = {
          exclude = {
            filetype = {'dap-view', 'NvimTree'},
            buftype = {'prompt'},
          },
        },
      },
      remove_file = {
        close_window = false,
      },
    },
    on_attach = function (bufnr)
      local treeapi = require('nvim-tree.api')
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
          node:expand_or_collapse()
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
      disable_for_dirs = {
        '/tmp',
        vim.uv.os_homedir(),
      },
    },
  })
end

require('arctgx.lazy').setupOnLoad('nvim-tree', {
  before = function () vim.cmd.packadd('nvim-tree.lua') end,
  after = setup,
})

local function focusOnFile()
  require('nvim-tree')
  local treeapi = require('nvim-tree.api')
  local bufPath = vim.fn.fnamemodify(api.nvim_buf_get_name(0), ':p')
  local realParent = vim.uv.fs_realpath(require('arctgx.base').getBufferCwd(0)) or
    vim.iter(vim.fs.parents(bufPath)):find(function (path)
      return vim.uv.fs_realpath(path) and path ~= '/'
    end) or vim.uv.cwd()
  treeapi.tree.open(require('arctgx.git').topOrFallback(realParent))
  -- treeapi.tree.toggle_hidden_filter()
  treeapi.live_filter.clear()
  local pathToFocus = vim.uv.fs_realpath(bufPath) or realParent

  treeapi.tree.find_file({
    buf = pathToFocus,
  })

  local function expandNode()
    local node = treeapi.tree.get_node_under_cursor()
    if node.name == '..' then
      return
    end
    treeapi.node.open.edit(node)
  end

  if vim.fn.isdirectory(pathToFocus) == 1 then
    expandNode()
  end
  vim.cmd.normal('zz')
end

require('arctgx.vim.abstractKeymap').set({'n'}, 'fileTreeFocus', focusOnFile)
require('arctgx.vim.abstractKeymap').set({'n'}, 'fileTreeToggle', function ()
  require('nvim-tree')
  local treeapi = require('nvim-tree.api')
  treeapi.tree.toggle()
end)

session.appendBeforeSaveHook('Close nvim-tree instances', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'NvimTree'}, function (winId)
    api.nvim_win_close(winId, false)
  end)
end)
