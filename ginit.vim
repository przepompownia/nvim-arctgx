if exists('g:GuiLoaded')
  call GuiWindowFullScreen(1)
  GuiPopupmenu v:false
  GuiTabline v:false
endif
set guifont=SauceCodePro\ Nerd\ Font\ Mono:style=Regular:h14
packadd vim-tmux-focus-events
call setenv('TMUX', v:null)
