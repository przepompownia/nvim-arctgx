local caseInsensivity = nil

local augroup = vim.api.nvim_create_augroup('cmdlineIgnoreCase', {clear = true})
vim.api.nvim_create_autocmd('CmdLineEnter', {
  group = augroup,
  pattern = ':',
  callback = function ()
    caseInsensivity = vim.opt.ignorecase:get()
    vim.opt.ignorecase = true
  end
})
vim.api.nvim_create_autocmd('CmdLineLeave', {
  group = augroup,
  pattern = ':',
  callback = function ()
    vim.opt.ignorecase = caseInsensivity
    caseInsensivity = nil
  end
})
