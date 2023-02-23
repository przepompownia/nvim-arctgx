vim.opt_global.guifont = 'SauceCodePro Nerd Font Mono:style=Regular:h14'
if vim.g.GuiLoaded then
  vim.fn.GuiWindowFullScreen(1)
  vim.cmd.GuiPopupmenu(false)
  vim.cmd.GuiTabline(false)
  vim.cmd.packadd 'vim-tmux-focus-events'
  vim.env.TMUX = nil
end
