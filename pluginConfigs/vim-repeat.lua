local augroup = vim.api.nvim_create_augroup('repeatPluginExtension', {clear = true})
vim.api.nvim_create_autocmd({'BufEnter', 'BufWritePost'}, {
  group = augroup,
  callback = function()
    vim.g.repeat_tick = vim.b.changedtick
  end,
})
