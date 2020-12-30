let g:arctgx_backupdir	= expand(g:initialVimDirectory . '/.config/backups')
nnoremap <Leader>wrb :call arctgx#writebackup#save()<CR>
let g:ArctgxGetGrepCmd = function('arctgx#grep#getRipGrepCmd')
