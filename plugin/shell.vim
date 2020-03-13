command Shell call arctgx#arctgx#openShell(fnamemodify(bufname(''), ':h'))

augroup terminalMode
  autocmd!
  if has('nvim')
    autocmd TermOpen * setlocal nonumber | startinsert
    autocmd TermClose * quit
  else
    autocmd TerminalOpen * startinsert
  endif
augroup END
