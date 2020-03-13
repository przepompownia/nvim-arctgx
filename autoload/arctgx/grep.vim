function! arctgx#grep#grep(...)
  let l:params = copy(a:000)
  call map(l:params, 'shellescape(v:val)')
  let l:paramstring = join(l:params, ' ')

  silent execute "lgrep! " . l:paramstring . ' .'
  lopen
  let w:quickfix_title = 'grep: ' . l:paramstring
endfunction

function! arctgx#grep#grepOperator(type)
  let l:saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  call arctgx#grep#grep('--recursive', '--', @@)

  let @@ = l:saved_unnamed_register
endfunction
