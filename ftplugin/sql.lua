vim.opt_local.isfname:append('`')
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.g.loaded_sql_completion = 1
vim.g.omni_sql_no_default_maps = 1
vim.g.ftplugin_sql_omni_key = '<Nop>'
vim.keymap.set({'n', 'i', 'v'}, '<F2>', vim.cmd.write, {buffer = 0, desc = 'Write SQL query'})
