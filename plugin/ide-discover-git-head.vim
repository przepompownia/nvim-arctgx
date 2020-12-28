augroup DiscoverGitHead
  autocmd!
  autocmd BufWinEnter,FocusGained * call arctgx#ide#recognizeGitHead(expand('<afile>'))
  if has('nvim')
    autocmd VimResume * call arctgx#ide#recognizeGitHead(expand('<afile>'))
  endif
augroup END
