function! arctgx#base#sourceFile(path) abort
  if !filereadable(a:path)
    throw printf('Config %s does not exist.', a:path)
    return
  endif

  execute 'source ' . a:path
endfunction

function! arctgx#base#getBufferDirectory() abort
  return (empty(&buftype) || &buftype ==# 'help') ? expand('%:p:h') : getcwd()
endfunction

function! s:getBufnrByPath(path) abort
  let l:filename = fnamemodify(a:path, ':p')
  let l:bufNr = bufnr(l:filename)

  return -1 == l:bufNr ? v:null : l:bufNr
endfunction

function! s:getFirstWinOfLoadedBuffer(bufNr) abort
  if (v:null is a:bufNr)
    return v:null
  endif

  let l:winIds = win_findbuf(a:bufNr)

  if empty(l:winIds)
    return v:null
  endif

  return l:winIds[0]
endfunction

function! arctgx#base#tabDrop(path, relativeWinNr = v:null) abort
  let l:winId = s:getFirstWinOfLoadedBuffer(s:getBufnrByPath(a:path))
  if v:null isnot# l:winId
    call win_gotoid(l:winId)
    return
  endif

  let l:relativeWinNr = a:relativeWinNr ? a:relativeWinNr : win_getid()

  if v:null isnot# l:relativeWinNr && getbufvar(winbufnr(l:relativeWinNr), 'changedtick') <= 2
    call win_gotoid(l:relativeWinNr)
    silent execute 'edit ' . a:path
    return
  endif

  silent execute 'tabedit ' . a:path
endfunction

function! arctgx#base#tabDropMulti(...) abort
  for l:filename in a:000
    call arctgx#base#tabDrop(l:filename)
  endfor
endfunction

function! arctgx#base#cursor(line = 0, column = 0) abort
  if a:line =~# '\D' || a:column =~# '\D'
    throw 'Expected line number'
  endif

  let l:line = empty(a:line) ? 0 : str2nr(a:line)
  let l:column = empty(a:column) ? 0 : str2nr(a:column)

  call cursor(l:line, l:column)
endfunction

function! arctgx#base#tabDropToLineAndColumn(path, line = 0, column = 0) abort
  call arctgx#base#tabDrop(a:path)

  if v:null is a:line
    return
  endif

  call arctgx#base#cursor(a:line, a:column)
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

  call arctgx#base#tabDropToLineAndColumn(l:path, a:line, a:column)
endfunction

function! arctgx#base#tabDropToLineAndColumnWithDefaultMapping(path, line = 0, column = 0) abort
  let l:mapping = get(g:, 'projectPathMappings', {})

  call arctgx#base#tabDropToLineAndColumnWithMapping(a:path, l:mapping, a:line, a:column)
endfunction
