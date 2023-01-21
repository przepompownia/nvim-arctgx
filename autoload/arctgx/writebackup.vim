function! arctgx#writebackup#save()
  let l:backupDir = get(g:, 'arctgx_backupdir', '/tmp')

  execute printf('write %s/%s.%d', l:backupDir, expand('%:t'), v:lua.math.random(0,9999))
endfunction
