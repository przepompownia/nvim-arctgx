autocmd BufNewFile,BufRead
  \ ~/.config/geeqie/accels
  \ set foldmethod=expr |
  \ set foldexpr=getline(v:lnum)=~'^;\\s*' |
  \ exe "normal zM``" |
  \ set ft=scheme
