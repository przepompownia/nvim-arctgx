local api = vim.api
vim.bo.modified = false
vim.bo.modifiable = false
vim.keymap.set({'v'}, 'q', vim.cmd.quit, {buffer = api.nvim_get_current_buf()})
vim.keymap.set({'n'}, '<Space>', '<C-f>', {buffer = api.nvim_get_current_buf()})
