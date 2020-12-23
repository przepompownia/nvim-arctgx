scriptencoding utf-8

function arctgx#ide#bufname() abort
  if exists('*arctgx#fugitiveline#bufname')
    return arctgx#fugitiveline#bufname()
  endif

  return bufname()
endfunction

function arctgx#ide#get_current_function() abort
  let l:funcname = get(b:, 'ide_current_function', '')

  if empty(l:funcname)
    return ''
  endif

  return printf('[::%s]', l:funcname)
endfunction

function arctgx#ide#showLocation() abort
  return arctgx#ide#bufname() . arctgx#ide#get_current_function()
endfunction

function arctgx#ide#showGitBranch() abort
  return arctgx#string#shorten(FugitiveHead())
endfunction

function arctgx#ide#showIsLastUsedWindow() abort
  return winnr() is winnr("#") ? ' [LW]' : ''
endfunction

function arctgx#ide#showWinInfo() abort
  return printf(
        \ 'b:%d, tw: %d.%d (%d)%s',
        \ bufnr(),
        \ tabpagenr(),
        \ winnr(),
        \ win_getid(),
        \ arctgx#ide#showIsLastUsedWindow(),
        \ )
endfunction

function arctgx#ide#displayFileNameInTab(tabNumber) abort
  let buflist = tabpagebuflist(a:tabNumber)
  let winnr = tabpagewinnr(a:tabNumber)
  let _ = expand('#'.buflist[winnr - 1].':p:t:r')

  return _ !=# '' ? _ : '[No Name]'
endfunction
