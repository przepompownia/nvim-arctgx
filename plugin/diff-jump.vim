nnoremap <silent> <Plug>arctgxDiffJumpToPrevious :<C-U>call arctgx#diffjump#jumpToPrevious(v:count1)<CR>
nnoremap <silent> <Plug>arctgxDiffJumpToNext :<C-U>call arctgx#diffjump#jumpToNext(v:count1)<CR>
nnoremap <Plug>arctgxSavedOldJumpToPrevious [c
nnoremap <Plug>arctgxSavedOldJumpToNext ]c
nmap ]c <Plug>arctgxDiffJumpToNext
nmap [c <Plug>arctgxDiffJumpToPrevious
