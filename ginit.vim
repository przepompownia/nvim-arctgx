call GuiWindowFullScreen(1)
GuiPopupmenu v:false
GuiTabline v:false
set background=light
packadd vim-tmux-focus-events
call setenv('TMUX', v:null)
