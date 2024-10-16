local api = vim.api

local session = require 'arctgx.session'
local keymap = require('arctgx.vim.abstractKeymap')

require('diffview').setup({
  use_icons = false,
  enhanced_diff_hl = true,
  file_panel = {
    listing_style = 'list',
    tree_options = {
      flatten_dirs = true,
      folder_statuses = 'only_folded'
    },
    win_config = {
      type = 'float',
      position = 'left',
      width = 120,
      height = 40,
      win_opts = {},
      border = 'rounded',
    },
  },
})

local function closeDiffviewTabs()
  require('arctgx.window').forEachWindowWithBufFileType({'DiffviewFiles', 'DiffviewFileHistory'}, function (winId)
    local tabNr = api.nvim_tabpage_get_number(api.nvim_win_get_tabpage(winId))
    vim.cmd.tabclose(tabNr)
  end)
end

keymap.set('n', 'gitLogAllFiles', function ()
  vim.cmd.DiffviewFileHistory()
end)
keymap.set('n', 'gitLogCurrentFile', function ()
  vim.cmd.DiffviewFileHistory({args = {'%'}})
end)
keymap.set('n', 'gitStatusUIOpen', function ()
  vim.cmd.DiffviewOpen()
end)
keymap.set('n', 'gitStatusUIClose', closeDiffviewTabs)

session.appendBeforeSaveHook('Close DiffView tabs', closeDiffviewTabs)

api.nvim_create_autocmd('FileType', {
  group = api.nvim_create_augroup('DiffViewBufEnter', {clear = true}),
  pattern = {'diffview://.*'},
  callback = function (args)
    require('arctgx.base').addBufferCwdCallback(args.buf, function ()
      return vim.uv.cwd()
    end)
  end,
})

api.nvim_create_autocmd({'FileType'}, {
  pattern = {'DiffviewFiles', 'DiffviewFileHistory'},
  group = api.nvim_create_augroup('DiffViewTabName', {clear = true}),
  callback = function (args)
    local tabpage = api.nvim_get_current_tabpage()
    vim.t[tabpage].arctgxTabName = args.match
  end
})

