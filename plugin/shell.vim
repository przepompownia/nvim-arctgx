command Shell call arctgx#arctgx#openShell(fnamemodify(bufname(''), ':h'))

augroup terminalMode
  autocmd!
  if has('nvim')
    autocmd TermOpen ++nested term://* setlocal nonumber | startinsert
    autocmd TermClose ++nested term://* quit
  else
    autocmd TerminalOpen ++nested term://* startinsert
  endif
augroup END
