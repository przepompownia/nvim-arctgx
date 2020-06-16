let g:arctgx_backupdir	= '~/.vim-zasoby/kopie'
nnoremap <Leader>wrb :call arctgx#writebackup#save()<CR>
let g:ArctgxGrepCallback = function('arctgx#grep#rgrep')
