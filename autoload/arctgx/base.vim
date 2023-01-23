function! arctgx#base#sourceFile(path) abort
  if !filereadable(a:path)
    throw printf('Config %s does not exist.', a:path)
    return
  endif

  execute 'source ' . a:path
endfunction

function! arctgx#base#tabDropToLineAndColumnWithMapping(path, mapping, line = 0, column = 0) abort
  let l:path = a:path

  for l:remotePath in keys(a:mapping)
    if a:path !~# '^' . l:remotePath
      continue
    endif

    let l:path = substitute(a:path, '^' . l:remotePath, a:mapping[l:remotePath], '')
    break
  endfor

  call v:lua.require'arctgx.base'.tab_drop(l:path, a:line, a:column)
endfunction

function! arctgx#base#tabDropToLineAndColumnWithDefaultMapping(path, line = 0, column = 0) abort
  let l:mapping = get(g:, 'projectPathMappings', {})

  call arctgx#base#tabDropToLineAndColumnWithMapping(a:path, l:mapping, a:line, a:column)
endfunction
