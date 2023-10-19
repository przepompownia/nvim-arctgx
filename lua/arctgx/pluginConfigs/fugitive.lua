local api = vim.api
local session = require 'arctgx.session'

local augroup = api.nvim_create_augroup('FugitiveConfig', {clear = true})
api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  pattern = 'fugitive://*',
  callback = function (params)
    vim.bo[params.buf].bufhidden = 'delete'
  end
})
api.nvim_create_autocmd('FileType', {
  pattern = {'git', 'fugitiveblame', 'fugitive'},
  group = augroup,
  callback = function (_params)
   vim.keymap.set('n', 'q', vim.cmd.quit)
  end
})
vim.keymap.set('n', '<Plug>(ide-git-log)', function ()
  vim.cmd.Gllog()
end)
vim.keymap.set('n', '<Plug>(ide-git-blame)', function ()
  vim.cmd.Git {'blame'}
end)
session.appendBeforeSaveHook('Close Fugitive windows', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'fugitiveblame'}, function (winId)
    api.nvim_win_close(winId, true)
  end)
end)
