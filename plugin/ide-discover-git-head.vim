augroup DiscoverGitHead
  autocmd!
  autocmd BufEnter,WinEnter,FocusGained * call arctgx#ide#recognizeGitHead(str2nr(expand('<abuf>')))
  if has('nvim')
    autocmd VimResume * call arctgx#ide#recognizeGitHead(str2nr(expand('<abuf>')))
  endif
augroup END
