local session = require 'arctgx.session'
local keymap = require('arctgx.vim.abstractKeymap')

require('diffview').setup({
  use_icons = false,
  enhanced_diff_hl = true,
})

local function closeDiffviewTabs()
  require('arctgx.window').forEachWindowWithBufFileType({'DiffviewFiles', 'DiffviewFileHistory'}, function (winId)
    local tabNr = vim.api.nvim_tabpage_get_number(vim.api.nvim_win_get_tabpage(winId))
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

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('BufEnter', {clear = true}),
  pattern = {'diffview://.*'},
  callback = function (args)
    require('arctgx.base').addBufferCwdCallback(args.buf, function ()
      return vim.uv.cwd()
    end)
  end,
})
