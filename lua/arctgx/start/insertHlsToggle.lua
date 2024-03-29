local augroup = vim.api.nvim_create_augroup('InsertHlsearchToggle', {clear = true})
vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  pattern = '*',
  callback = function ()
    vim.b.savedHlsearch = vim.opt_local.hlsearch:get()
    vim.go.hlsearch = false
  end
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = augroup,
  pattern = '*',
  callback = function ()
    vim.go.hlsearch = vim.b.savedHlsearch or true
  end
})
