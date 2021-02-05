scriptencoding utf-8

function! arctgx#string#shorten(name, margin) abort
  let l:coupler = '…'

  if (strlen(a:name) <= strchars(l:coupler)+2*a:margin)
    return a:name
  endif

  return printf(
        \ '%s%s%s',
        \ strcharpart(a:name, 0, a:margin),
        \ l:coupler,
        \ strcharpart(a:name, strchars(a:name) - a:margin, a:margin)
        \ )
endfunction

function! arctgx#string#tail(text, length) abort
  return strcharpart(a:text, strwidth(a:text) - a:length)
endfunction
