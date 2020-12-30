autocmd TabEnter,WinEnter,BufReadPost,FileReadPost,BufNewFile * execute 'let &titlestring = exists("*xolox#session#find_current_session") ? xolox#session#find_current_session() : "[no vim-session] " . expand("%:t")'
let g:session_autosave		= 'no'
let g:session_autoload		= 'no'
