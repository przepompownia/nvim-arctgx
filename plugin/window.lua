local augroup = vim.api.nvim_create_augroup('WindowHistory', {clear = true})
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  callback = function ()
    return require('arctgx.windowhistory').createFromWindowList()
  end,
})
vim.api.nvim_create_autocmd('WinEnter', {
  group = augroup,
  callback = function ()
    return require('arctgx.window').onWinEnter()
  end,
  nested = true,
})
vim.api.nvim_create_autocmd('WinClosed', {
  group = augroup,
  callback = function (params)
    require('arctgx.window').onWinClosed(tonumber(params.file))
  end,
  nested = true,
})

vim.keymap.set('n', '<Plug>(ide-close-popup)', vim.cmd.fclose)
