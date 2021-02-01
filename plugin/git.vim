command! -bang -nargs=+ GFDiff call arctgx#git#fzf#diff(
      \ function('arctgx#git#fzf#serializeGFDiffCommand'),
      \ arctgx#git#gitGetWorkspaceRoot(expand('%:p:h')),
      \ <bang>0,
      \ <f-args>,
      \ )

command! -bang -nargs=* GFBranch call arctgx#git#fzf#branch(
      \ arctgx#git#gitGetWorkspaceRoot(expand('%:p:h')),
      \ <bang>0,
      \ )
