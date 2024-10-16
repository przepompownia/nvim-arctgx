local api = vim.api
if #api.nvim_tabpage_list_wins(0) > 1 then
  vim.cmd.wincmd('T')
end
vim.bo.modified = false
vim.bo.modifiable = false
vim.keymap.set({'n', 'v'}, 'q', vim.cmd.quit, {buffer = api.nvim_get_current_buf()})
vim.keymap.set({'n'}, '<Space>', '<C-f>', {buffer = api.nvim_get_current_buf()})
