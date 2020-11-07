function arctgx#operator#getText(type) abort
  let l:saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  let l:query = @@

  let @@ = l:saved_unnamed_register

  return l:query
endfunction
