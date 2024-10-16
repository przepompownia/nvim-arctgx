local api = vim.api

vim.keymap.set('n', 'q', vim.cmd.quit, {buffer = api.nvim_get_current_buf()})
vim.keymap.set('n', '<Esc>', vim.cmd.quit, {buffer = api.nvim_get_current_buf()})
vim.wo.cursorline = true
