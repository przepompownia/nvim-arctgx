augroup WindowHistory
  autocmd!
  autocmd VimEnter * call arctgx#windowhistory#createFromWindowList()
  autocmd! WinClosed * ++nested
        \ call arctgx#windowhistory#remove(str2nr(expand('<afile>'))) |
        \ call arctgx#windowhistory#jumpOnTop()
  autocmd! WinEnter *
        \ call arctgx#windowhistory#putOnTop(win_getid())
augroup END
nmap <Plug>(jump-last-tab) :exe 'tabn ' . g:lastTab<cr>

command! -complete=file -nargs=+ TabDrop call arctgx#base#tabDropMulti(<f-args>)
command! -complete=file -nargs=+ T call arctgx#base#tabDropMulti(<f-args>)
