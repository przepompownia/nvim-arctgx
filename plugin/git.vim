command! -bang -nargs=* GFDiff call arctgx#git#fzf#diff(
      \ function('arctgx#git#fzf#gregex'),
      \ arctgx#git#gitGetWorkspaceRoot(expand('%:p:h')),
      \ <q-args>,
      \ '',
      \ <bang>0,
      \ )
