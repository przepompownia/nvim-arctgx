if exists('g:GuiLoaded')
  call GuiWindowFullScreen(1)
  GuiPopupmenu v:false
  GuiTabline v:false
endif
packadd vim-tmux-focus-events
call setenv('TMUX', v:null)
