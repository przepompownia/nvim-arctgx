vim.opt_global.guifont = 'SauceCodePro Nerd Font Mono:h14'
if vim.g.GuiLoaded then
  vim.fn.GuiWindowFullScreen(1)
  vim.cmd.GuiPopupmenu(false)
  vim.cmd.GuiTabline(false)
  vim.cmd.GuiFont({args = {vim.opt_global.guifont:get()[1]}, bang = true})
  vim.cmd.packadd 'vim-tmux-focus-events'
  vim.env.TMUX = nil
end

local augroupGinit = vim.api.nvim_create_augroup('AfterGinit', {clear = true})
vim.api.nvim_create_autocmd('FocusGained', {
  group = augroupGinit,
  pattern = '*',
  callback = function ()
    vim.cmd.checktime()
  end,
})
