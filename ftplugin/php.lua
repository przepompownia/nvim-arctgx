vim.opt_local.iskeyword:remove('$')
vim.opt_local.spell = true
vim.opt_local.wrap = false
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.keymap.set('i', '<A-.>', '->', {buffer = true})
vim.keymap.set('i', '<A-char-62>', '=>', {buffer = true})
