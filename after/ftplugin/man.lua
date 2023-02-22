vim.cmd.wincmd('T')
vim.bo.modified = false
vim.bo.modifiable = false
vim.keymap.set({'n', 'v'}, 'q', vim.cmd.quit, {buffer = vim.api.nvim_get_current_buf()})
vim.keymap.set({'n'}, '<Space>', '<C-f>', {buffer = vim.api.nvim_get_current_buf()})
