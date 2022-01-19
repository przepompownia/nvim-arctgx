local base = require('arctgx.base')
local opts = {nargs = '+', complete = 'file'}
local tab_drop = function(opts) base.tab_drop_path(opts.args) end

vim.api.nvim_add_user_command('TabDrop', tab_drop, opts)
vim.api.nvim_add_user_command('T', tab_drop, opts)
