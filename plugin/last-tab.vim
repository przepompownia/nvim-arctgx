if !exists('g:lastTab')
    let g:lastTab = 1
    let g:lastTabBackup = 1
endif
augroup LastTab
  autocmd!
  autocmd! TabLeave *
        \ let g:lastTabBackup = g:lastTab |
        \ let g:lastTab = tabpagenr()
  autocmd! TabClosed * let g:lastTab = g:lastTabBackup
augroup END
nmap <Plug>(jump-last-tab) :exe 'tabn ' . g:lastTab<cr>
