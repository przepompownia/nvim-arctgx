autocmd BufNewFile,BufRead
  \ ~/.bash.d/*,~/.local/share/bash-completion/completions/*
  \ let g:is_bash = 1 |
  \ set ft=sh
