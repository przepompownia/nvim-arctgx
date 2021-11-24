function! arctgx#windowhistory#createFromWindowList() abort
  let s:history = arctgx#history#create(getwininfo()->map({_, x -> x.winid}))
endfunction

function! arctgx#windowhistory#jumpOnTop() abort
  call win_gotoid(s:history.top())
endfunction

function! arctgx#windowhistory#jumpBack() abort
  call win_gotoid(s:history.previous())
endfunction

function! arctgx#windowhistory#getInstance() abort
  return get(s:, 'history', arctgx#windowhistory#createFromWindowList())
endfunction
