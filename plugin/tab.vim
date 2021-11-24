augroup WindowHistory
  autocmd!
  autocmd VimEnter * call arctgx#windowhistory#createFromWindowList()
  autocmd WinEnter * ++nested call s:onWinEnter()
  autocmd WinClosed * ++nested call s:onWinClosed(str2nr(expand('<afile>')))
augroup END

command! -complete=file -nargs=+ TabDrop call arctgx#base#tabDropMulti(<f-args>)
command! -complete=file -nargs=+ T call arctgx#base#tabDropMulti(<f-args>)

function s:onWinEnter() abort
  if ('popup' ==# win_gettype())
    return
  endif

  call arctgx#windowhistory#getInstance().putOnTop(win_getid())
endfunction

function s:onWinClosed(winId) abort
  if ('popup' ==# win_gettype(a:winId))
    return
  endif

  call arctgx#windowhistory#getInstance().remove(a:winId)
  call arctgx#windowhistory#jumpOnTop()
endfunction
