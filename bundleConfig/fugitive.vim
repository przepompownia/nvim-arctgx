augroup FugitiveConfig
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd User FugitiveChanged doautocmd <nomodeline> User ChangeIdeStatus
augroup end
nmap <Leader>gs :Gstatus<CR><C-w>33+
nmap <Leader>gl :Glog<CR>
nmap <Plug>(ide-git-stage-write-file) :Gwrite<CR>
