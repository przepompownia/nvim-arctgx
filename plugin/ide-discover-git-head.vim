augroup DiscoverGitHead
  autocmd!
  autocmd WinEnter,FocusGained * doautocmd <nomodeline> User ChangeIdeStatus
  autocmd VimResume * doautocmd <nomodeline> User ChangeIdeStatus

  autocmd User ChangeIdeStatus call arctgx#ide#recognizeGitHeadsInTab()
augroup END
