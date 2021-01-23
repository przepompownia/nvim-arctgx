augroup DiscoverGitHead
  autocmd!
  autocmd WinEnter,FocusGained * call arctgx#ide#recognizeGitHeadsInTab()
  if has('nvim')
    autocmd VimResume * call arctgx#ide#recognizeGitHeadsInTab()
  endif
augroup END
