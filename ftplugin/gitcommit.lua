vim.wo.cursorline = true
vim.wo.number = false
vim.wo.relativenumber = false
vim.cmd.startinsert()
vim.api.nvim_create_autocmd({'BufUnload'}, {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function ()
    vim.cmd.stopinsert()
  end,
})
