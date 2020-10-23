setlocal iskeyword-=$
setlocal nowrap
setlocal softtabstop=4 shiftwidth=4 expandtab
inoremap <buffer> <A-.> ->
inoremap <buffer> <A-char-62> =>
let b:delimitMate_matchpairs = '(:),{:},[:]'

augroup phpCompleteDone
  autocmd!
  autocmd CompleteDone <buffer> if (get(v:completed_item, 'kind', v:null) ==# 'f') && (get(v:completed_item, 'word', v:null) !~# '($')
        \ | call feedkeys("(")
        \ | endif
augroup END
