function! s:getRandomNumber()
  let l:random = 0
  py3 << EOF
import random; print()
vim.command("let %s = '%s'" % ("l:random", random.randint(0, 99999)))
EOF
  return l:random
endfunction

function! arctgx#writebackup#save()
  let l:backupDir = get(g:, 'arctgx_backupdir', '/tmp')

  execute printf('write %s/%s.%d', l:backupDir, expand('%:t'), s:getRandomNumber())
endfunction
