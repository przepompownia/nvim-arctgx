augroup cmdlineIgnoreCase
  autocmd!
  autocmd CmdLineEnter : let g:case_insensivity = &ignorecase | set ignorecase
  autocmd CmdLineLeave : let &ignorecase = g:case_insensivity | unlet g:case_insensivity
augroup END
