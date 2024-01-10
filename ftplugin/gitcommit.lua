vim.wo.cursorline = true
vim.opt_local.number = false
vim.cmd.startinsert()
vim.api.nvim_create_autocmd({'BufUnload'}, {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function ()
    vim.cmd.stopinsert()
  end,
})
