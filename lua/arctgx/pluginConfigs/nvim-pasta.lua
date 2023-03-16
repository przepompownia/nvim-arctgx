vim.keymap.set({ 'n', 'x' }, ']p', require('pasta.mappings').p)
vim.keymap.set({ 'n', 'x' }, '[p', require('pasta.mappings').P)
vim.keymap.set({ 'n' }, '<C-p>', require('pasta.mappings').toggle_pin)
