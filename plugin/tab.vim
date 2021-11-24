augroup WindowHistory
  autocmd!
  autocmd VimEnter * call arctgx#windowhistory#createFromWindowList()
  autocmd WinEnter * ++nested call arctgx#window#onWinEnter()
  autocmd WinClosed * ++nested call arctgx#window#onWinClosed(str2nr(expand('<afile>')))
augroup END

command! -complete=file -nargs=+ TabDrop call arctgx#base#tabDropMulti(<f-args>)
command! -complete=file -nargs=+ T call arctgx#base#tabDropMulti(<f-args>)
