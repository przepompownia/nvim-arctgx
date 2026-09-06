local api = vim.api
require('arctgx.lazy').setupOnLoad('diffview.lazy', {
  before = function ()
    -- avoid :runtime plugin/...
    vim.cmd.packadd {'diffview.nvim', bang = true}
  end,
  after = function ()
    -- :runtime plugin/...
    vim.cmd.packadd {'diffview.nvim'}
    require('diffview').setup({
      use_icons = false,
      enhanced_diff_hl = true,
      clean_up_buffers = true,
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
  end,
})

local session = require 'arctgx.session'
local keymap = require('arctgx.vim.abstractKeymap')

local function closeDiffviewTabs()
  require('arctgx.window').forEachWindowWithBufFileType({'DiffviewFiles', 'DiffviewFileHistory'}, function (winId)
    local tabNr = api.nvim_tabpage_get_number(api.nvim_win_get_tabpage(winId))
    vim.cmd.tabclose(tabNr)
  end)
end

keymap.set('n', 'gitLogAllFiles', function ()
  require('diffview.lazy').require('diffview').file_history(nil, {})
end)
keymap.set('n', 'gitLogCurrentFile', function ()
  require('diffview.lazy').require('diffview').file_history(nil, {'%'})
end)
keymap.set('n', 'gitStatusUIOpen', function ()
  require('diffview.lazy').require('diffview').toggle()
end)
vim.keymap.set({'n'}, '<Leader>gv', function ()
  require('diffview.lazy')
  api.nvim_feedkeys(':Diffview', 't', false)
end, {})

session.writePre('Close DiffView tabs', closeDiffviewTabs)

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
