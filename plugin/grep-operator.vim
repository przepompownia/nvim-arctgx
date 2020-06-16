" http://learnvimscriptthehardway.stevelosh.com/chapters/32.html

" Example: <leader>qiw
nnoremap <leader>q :set operatorfunc=arctgx#grep#grepOperator<cr>g@
vnoremap <leader>q :<c-u>call arctgx#grep#grepOperator(visualmode())<cr>
if has('nvim')
  nmap <Plug>(ide-grep-git) <Cmd>:GGrep<CR>
  nmap <Plug>(ide-grep-files) <Cmd>:RGrep<CR>
else
  nmap <Plug>(ide-grep-git) :<C-U>GGrep<CR>
  nmap <Plug>(ide-grep-files) :<C-U>RGrep<CR>
endif

command! -bang -nargs=* GGrep call arctgx#grep#ggrep(<q-args>, <bang>0)
command! -bang -nargs=* RGrep call arctgx#grep#rgrep(<q-args>, <bang>0)
