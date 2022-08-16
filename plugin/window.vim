augroup WindowHistory
  autocmd!
  autocmd VimEnter * call arctgx#windowhistory#createFromWindowList()
  autocmd WinEnter * ++nested call arctgx#window#onWinEnter()
  autocmd WinClosed * ++nested call arctgx#window#onWinClosed(str2nr(expand('<afile>')))
augroup END

nmap <Plug>(ide-close-popup) <Cmd>call arctgx#window#closePopupForTab()<CR>
