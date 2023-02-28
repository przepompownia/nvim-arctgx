if vim.opt_local.buftype:get() ~= 'help' then
  return
end

vim.keymap.set({'n'}, 'q', function ()
  vim.api.nvim_buf_delete(0, {})
end, {buffer = 0})

-- WinClosed not triggered
require('arctgx.windowhistory').getInstance():remove(vim.api.nvim_get_current_win())
vim.cmd([[silent wincmd T]])
