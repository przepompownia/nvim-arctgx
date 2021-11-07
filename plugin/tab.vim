augroup WindowHistory
  autocmd!
  autocmd VimEnter * call arctgx#windowhistory#createFromWindowList()
  autocmd! WinClosed * ++nested
        \ call arctgx#windowhistory#getInstance().remove(str2nr(expand('<afile>'))) |
        \ call arctgx#windowhistory#jumpOnTop()
  autocmd! WinEnter *
        \ call arctgx#windowhistory#getInstance().putOnTop(win_getid())
augroup END

command! -complete=file -nargs=+ TabDrop call arctgx#base#tabDropMulti(<f-args>)
command! -complete=file -nargs=+ T call arctgx#base#tabDropMulti(<f-args>)
