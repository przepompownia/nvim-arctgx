function arctgx#string#shorten(name)
  let l:margin = 11
  let l:coupler = '…'

  if (strlen(a:name) <= strchars(l:coupler)+2*l:margin)
    return a:name
  endif

  return printf(
        \ '%s%s%s',
        \strcharpart(a:name, 0, l:margin),
        \ l:coupler,
        \ strcharpart(a:name, strchars(a:name) - l:margin, l:margin)
        \ )
endfunction
