let g:arctgx_backupdir	= expand(getenv('XDG_CONFIG_HOME') .. '/.config/backups')
nnoremap <Plug>(ide-write-backup) :call arctgx#writebackup#save()<CR>
