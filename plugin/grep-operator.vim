" http://learnvimscriptthehardway.stevelosh.com/chapters/32.html

" Example: <leader>qiw
nnoremap <leader>q :set operatorfunc=arctgx#grep#grepOperator<cr>g@
vnoremap <leader>q :<c-u>call arctgx#grep#grepOperator(visualmode())<cr>
