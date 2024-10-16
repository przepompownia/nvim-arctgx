local api = vim.api
local caseInsensivity = nil

local augroup = api.nvim_create_augroup('cmdlineIgnoreCase', {clear = true})
api.nvim_create_autocmd('CmdLineEnter', {
  group = augroup,
  pattern = ':',
  callback = function ()
    caseInsensivity = vim.go.ignorecase
    vim.opt.ignorecase = true
  end
})
api.nvim_create_autocmd('CmdLineLeave', {
  group = augroup,
  pattern = ':',
  callback = function ()
    vim.go.ignorecase = caseInsensivity
    caseInsensivity = nil
  end
})
