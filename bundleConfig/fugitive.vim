augroup FugitiveConfig
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd User FugitiveChanged doautocmd <nomodeline> User ChangeIdeStatus
  autocmd FileType gitcommit inoremap <buffer> <F3> <C-\><C-n>:q<CR>
  autocmd FileType git,fugitiveblame,fugitive nmap <buffer> q :q<CR>
augroup end
nmap <Plug>(ide-git-status) :G<CR><C-w>33+
nmap <Plug>(ide-git-log) :Glog<CR>
nmap <Plug>(ide-git-push-all) :Git pushall<CR>
nmap <Plug>(ide-git-commit) :Git commit<CR>
nmap <Plug>(ide-git-blame) :Git blame<CR>
nmap <Plug>(ide-git-stage-write-file) :Gwrite<CR>
