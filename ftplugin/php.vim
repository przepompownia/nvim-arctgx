setlocal iskeyword-=$
setlocal nowrap
let b:commentary_format='//\ %s'
setlocal softtabstop=4 shiftwidth=4 expandtab
inoremap <buffer> <A-.> ->
let b:delimitMate_matchpairs = '(:),{:},[:]'
