augroup DiscoverGitHead
  autocmd!
  autocmd WinEnter,FocusGained * doautocmd <nomodeline> User ChangeIdeStatus
  autocmd VimResume * doautocmd <nomodeline> User ChangeIdeStatus
augroup END
