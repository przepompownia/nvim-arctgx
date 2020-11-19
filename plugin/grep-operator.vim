" http://learnvimscriptthehardway.stevelosh.com/chapters/32.html

" Example: <leader>qiw
nnoremap <leader>q :set operatorfunc=arctgx#grep#grepOperator<cr>g@
vnoremap <leader>q :<c-u>call arctgx#grep#grepOperator(visualmode())<cr>
nnoremap <leader>w :set operatorfunc=arctgx#grep#gitGrepOperator<cr>g@
vnoremap <leader>w :<c-u>call arctgx#grep#gitGrepOperator(visualmode())<cr>
if has('nvim')
  nmap <Plug>(ide-grep-git) <Cmd>GGrep<CR>
  nmap <Plug>(ide-grep-files) <Cmd>RGrep<CR>
else
  nmap <Plug>(ide-grep-git) :<C-U>GGrep<CR>
  nmap <Plug>(ide-grep-files) :<C-U>RGrep<CR>
endif

command! -bang -nargs=* GGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getGitGrepCmd'),
      \ arctgx#grep#gitGetWorkspaceRoot(expand('%:p:h')),
      \ <q-args>,
      \ v:false,
      \ <bang>0
      \ )
command! -bang -nargs=* RGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getRipGrepCmd'),
      \ getcwd(),
      \ <q-args>,
      \ v:false,
      \ <bang>0
      \ )
