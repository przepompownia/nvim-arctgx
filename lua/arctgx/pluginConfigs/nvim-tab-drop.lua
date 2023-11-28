local nvimTabDrop = require('nvim-tab-drop')
local tabDrop = function (opts) nvimTabDrop(opts.args) end
local opts = {nargs = '1', complete = 'file'}

vim.api.nvim_create_user_command('TabDrop', tabDrop, opts)
vim.api.nvim_create_user_command('T', tabDrop, opts)
require('arctgx.base').setTabDropReplacement(nvimTabDrop)
