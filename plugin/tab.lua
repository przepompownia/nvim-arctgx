local base = require('arctgx.base')
local tabDrop = function (opts) base.tabDrop(opts.args) end
local opts = {nargs = '+', complete = 'file'}

vim.api.nvim_create_user_command('TabDrop', tabDrop, opts)
vim.api.nvim_create_user_command('T', tabDrop, opts)
