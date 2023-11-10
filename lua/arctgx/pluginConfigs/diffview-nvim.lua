local session = require 'arctgx.session'

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

vim.keymap.set('n', '<Plug>(ide-git-log-all-files)', function ()
  vim.cmd.DiffviewFileHistory()
end)
vim.keymap.set('n', '<Plug>(ide-git-log-current-file)', function ()
  vim.cmd.DiffviewFileHistory({args = {'%'}})
end)
vim.keymap.set('n', '<Plug>(ide-git-status-open)', function ()
  vim.cmd.DiffviewOpen()
end)
vim.keymap.set('n', '<Plug>(ide-git-status-close)', closeDiffviewTabs)

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
