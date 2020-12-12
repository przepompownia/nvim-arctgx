scriptencoding utf-8

function airline#extensions#ide#bufname() abort
  if exists('*airline#extensions#fugitiveline#bufname')
    return airline#extensions#fugitiveline#bufname()
  endif

  return bufname()
endfunction

function airline#extensions#ide#get_current_function() abort
  let l:funcname = get(b:, 'ide_current_function', '')

  if empty(l:funcname)
    return ''
  endif

  return printf('[::%s]', l:funcname)
endfunction

function! airline#extensions#ide#init(ext) abort
  call airline#parts#define_function('ide_current_function', 'airline#extensions#coc#get_error')
endfunction
