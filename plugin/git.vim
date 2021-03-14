command! -bang -nargs=+ GFDiff call arctgx#git#fzf#diff(
      \ function('arctgx#git#fzf#serializeGFDiffCommand'),
      \ arctgx#git#getWorkspaceRoot(expand('%:p:h')),
      \ <bang>0,
      \ <f-args>,
      \ )

command! -bang -nargs=* GFBranch call arctgx#git#fzf#branch(
      \ arctgx#git#getWorkspaceRoot(expand('%:p:h')),
      \ <bang>0,
      \ )

nmap <Plug>(ide-git-show-branches) :<C-U>GFBranch!<CR>
