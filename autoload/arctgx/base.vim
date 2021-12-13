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

function! s:getTabOfLoadedFile(path) abort
  let l:filename = fnamemodify(a:path, ':p')
  let l:bufNr = bufnr(l:filename)
  for l:i in range(tabpagenr('$'))
    let l:tabnr = l:i + 1
    if index(tabpagebuflist(l:tabnr), l:bufNr) >= 0
      return l:tabnr
    endif
  endfor

  return v:null
endfunction

function! arctgx#base#tabDrop(path) abort
  let l:tabNr = s:getTabOfLoadedFile(a:path)

  if v:null isnot# l:tabNr
    silent execute 'tabnext ' . l:tabNr
    silent execute 'drop ' . a:path
    return
  endif

  let l:curentBufInfo = getbufinfo('%')[0]

  if l:curentBufInfo.name ==# '' && l:curentBufInfo.changed ==# 0
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
