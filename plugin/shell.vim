command Shell call arctgx#arctgx#openShell(fnamemodify(bufname(''), ':h'))

augroup terminalMode
  autocmd!
  if has('nvim')
    autocmd TermOpen term://* setlocal nonumber | startinsert
    autocmd TermClose term://* quit
  else
    autocmd TerminalOpen term://* startinsert
  endif
augroup END
