function! arctgx#file#findFileOperator(type) abort
  let l:query = arctgx#operator#getText(a:type)
  call fzf#vim#files('', fzf#vim#with_preview({'options': ['--query', l:query]}), 1)
endfunction
