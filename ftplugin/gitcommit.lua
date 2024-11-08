local api = vim.api

vim.bo.iskeyword = vim.bo.iskeyword .. ',-'
vim.wo.cursorline = true
vim.wo.number = false
vim.wo.relativenumber = false
vim.cmd.startinsert()
api.nvim_create_autocmd({'BufUnload'}, {
  buffer = api.nvim_get_current_buf(),
  callback = function ()
    vim.cmd.stopinsert()
  end,
})
