function arctgx#highlight#highlight(hlID, background, foreground) abort
  let l:background = s:determineColor('bg#', a:background)
  let l:foreground = s:determineColor('fg#', a:foreground)

  execute printf('highlight %s guibg=%s guifg=%s', a:hlID, l:background, l:foreground)
endfunction

function arctgx#highlight#getExistingHighlight(hlID, mode) abort
  return synIDattr(synIDtrans(hlID(a:hlID)), a:mode)
endfunction

function s:determineColor(mode, value) abort
  if stridx(a:value, '#') == 0
    return a:value
  endif

  let l:existingHighlight = arctgx#highlight#getExistingHighlight(a:value, a:mode)

  if 0 is l:existingHighlight
    return 'NONE'
  endif

  return l:existingHighlight
endfunction
