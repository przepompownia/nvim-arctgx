function arctgx#windowhistory#createFromWindowList() abort
  let s:history = getwininfo()->map({_, x -> x.winid})
endfunction

function! arctgx#windowhistory#remove(windowId) abort
  if !s:exists(a:windowId)
    return
  endif
  return s:history->remove(s:history->index(a:windowId))
endfunction

function! arctgx#windowhistory#jumpOnTop() abort
  call win_gotoid(get(s:history, 0, v:null))
endfunction

function! arctgx#windowhistory#jumpBack() abort
  call win_gotoid(get(s:history, 1, v:null))
endfunction

function! arctgx#windowhistory#putOnTop(windowId) abort
  if s:exists(a:windowId)
    call arctgx#windowhistory#remove(a:windowId)
  endif
  return s:history->insert(a:windowId)
endfunction

function! arctgx#windowhistory#show() abort
  return s:history
endfunction

function! s:exists(windowId) abort
  return s:history->index(a:windowId) >= 0
endfunction

let s:history = []
