let g:AutoPairsDisableBeforeNonSpace = 1
augroup autoPairsCustomPairs
  autocmd!
  autocmd filetype php let b:AutoPairs = g:AutoPairs
augroup END
