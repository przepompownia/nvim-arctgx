command Shell call arctgx#arctgx#openShell(fnamemodify(bufname(''), ':h'))

augroup terminalMode
  autocmd!
  autocmd TermOpen ++nested term://* setlocal nonumber | startinsert
  autocmd TermClose ++nested term://* quit
augroup END
