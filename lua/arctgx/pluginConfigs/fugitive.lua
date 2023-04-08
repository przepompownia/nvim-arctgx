local api = vim.api
local session = require 'arctgx.session'

local augroup = api.nvim_create_augroup('FugitiveConfig', {clear = true})
api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  pattern = 'fugitive://*',
  callback = function (params)
    api.nvim_buf_set_option(params.buf, 'bufhidden', 'delete')
  end
})
api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  group = augroup,
  callback = function (params)
    vim.cmd([[
      inoremap <buffer> <F3> <C-\><C-n>:q<CR>
    ]])
  end
})
api.nvim_create_autocmd('FileType', {
  pattern = {'git', 'fugitiveblame', 'fugitive'},
  group = augroup,
  callback = function (params)
   vim.keymap.set('n', 'q', vim.cmd.quit)
  end
})
vim.keymap.set('n', '<Plug>(ide-git-status)', function ()
  vim.cmd.Git()
  vim.cmd.resize(33)
end)
vim.keymap.set('n', '<Plug>(ide-git-log)', function ()
  vim.cmd.Gllog()
end)
vim.keymap.set('n', '<Plug>(ide-git-commit)', function ()
  vim.cmd.Git {'commit'}
end)
vim.keymap.set('n', '<Plug>(ide-git-blame)', function ()
  vim.cmd.Git {'blame'}
end)
session.appendBeforeSaveHook('Close Fugitive windows', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'fugitiveblame'}, function (winId)
    api.nvim_win_close(winId, true)
  end)
end)
