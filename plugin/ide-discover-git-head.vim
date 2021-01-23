augroup DiscoverGitHead
  autocmd!
  autocmd WinEnter,FocusGained * doautocmd <nomodeline> User ChangeIdeStatus
  if has('nvim')
    autocmd VimResume * doautocmd <nomodeline> User ChangeIdeStatus
  endif

  autocmd User ChangeIdeStatus call arctgx#ide#recognizeGitHeadsInTab()
augroup END
