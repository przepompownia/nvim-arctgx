vim.keymap.set('n', 'q', vim.cmd.quit, {buffer = vim.api.nvim_get_current_buf()})
vim.keymap.set('n', '<Esc>', vim.cmd.quit, {buffer = vim.api.nvim_get_current_buf()})
vim.wo.cursorline = true
