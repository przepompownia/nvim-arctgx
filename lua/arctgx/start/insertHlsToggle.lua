local api = vim.api

local augroup = api.nvim_create_augroup('InsertHlsearchToggle', {clear = true})
api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  pattern = '*',
  callback = function ()
    vim.b.savedHlsearch = vim.go.hlsearch
    vim.go.hlsearch = false
  end
})
api.nvim_create_autocmd('InsertLeave', {
  group = augroup,
  pattern = '*',
  callback = function ()
    vim.go.hlsearch = vim.b.savedHlsearch or true
  end
})
