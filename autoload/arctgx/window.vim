function! arctgx#window#isPopup(winId) abort
  return 'popup' ==# win_gettype(a:winId)
endfunction

function! arctgx#window#onWinEnter() abort
  if (arctgx#window#isPopup(win_getid()))
    return
  endif

  call arctgx#windowhistory#getInstance().putOnTop(win_getid())
endfunction

function! arctgx#window#onWinClosed(winId) abort
  if (arctgx#window#isPopup(a:winId))
    return
  endif

  call arctgx#windowhistory#getInstance().remove(a:winId)
  call arctgx#windowhistory#jumpOnTop()
  if nvim_win_is_valid(a:winId)
    call nvim_win_close(a:winId, v:true)
  endif
endfunction

function! arctgx#window#closePopupForTab() abort
  if (!has('nvim'))
    return
  endif

  call nvim_tabpage_list_wins(0)
        \ ->filter({_,v -> arctgx#window#isPopup(v)})
        \ ->map({_,v -> nvim_win_is_valid(v) && nvim_win_close(v, v:true)})
endfunction
