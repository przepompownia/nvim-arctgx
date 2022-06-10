function! arctgx#diffjump#jumpToPrevious(count)
  execute 'normal ' .. a:count .. "\<Plug>arctgxSavedOldJumpToPrevious"
  silent! call repeat#set("\<Plug>arctgxDiffJumpToPrevious", a:count)
endfunction

function! arctgx#diffjump#jumpToNext(count)
  execute 'normal ' .. a:count .. "\<Plug>arctgxSavedOldJumpToNext"
  silent! call repeat#set("\<Plug>arctgxDiffJumpToNext", a:count)
endfunction
