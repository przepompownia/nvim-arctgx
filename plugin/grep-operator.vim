" http://learnvimscriptthehardway.stevelosh.com/chapters/32.html

" Example: <leader>qiw
nnoremap <leader>q :set operatorfunc=arctgx#grep#grepOperator<cr>g@
vnoremap <leader>q :<c-u>call arctgx#grep#grepOperator(visualmode())<cr>
nnoremap <leader>w :set operatorfunc=arctgx#grep#gitGrepOperator<cr>g@
vnoremap <leader>w :<c-u>call arctgx#grep#gitGrepOperator(visualmode())<cr>
nmap <Plug>(ide-grep-git) <Cmd>GGrep!<CR>
nmap <Plug>(ide-grep-files) <Cmd>RGrep!<CR>

command! -bang -nargs=* GGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getGitGrepCmd'),
      \ arctgx#git#getWorkspaceRoot(arctgx#base#getBufferDirectory()),
      \ <q-args>,
      \ v:false,
      \ v:false,
      \ <bang>0,
      \ )
command! -bang -nargs=* RGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getRipGrepCmd'),
      \ getcwd(),
      \ <q-args>,
      \ v:false,
      \ v:false,
      \ <bang>0
      \ )
