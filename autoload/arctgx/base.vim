function arctgx#base#sourceFile(path)
  if !filereadable(a:path)
    throw printf('Config %s does not exist.', a:path)
    return
  endif

  execute 'source ' . a:path
endfunction

function arctgx#base#getBufferDirectory()
  return empty(&buftype) ? expand('%:p:h') : getcwd()
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

  if v:null is l:tabNr
    execute 'tabedit ' . a:path
    return
  endif

  execute 'tabnext ' . l:tabNr
endfunction

function! arctgx#base#tabDropMulti(...) abort
  for l:filename in a:000
    call arctgx#base#tabDrop(l:filename)
  endfor
endfunction
