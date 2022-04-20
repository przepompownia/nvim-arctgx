command! -bang -nargs=+ -complete=customlist,arctgx#git#completion#completeGFDiff GFDiff call arctgx#git#fzf#diff(
      \ function('arctgx#git#fzf#serializeGFDiffCommand'),
      \ arctgx#git#getWorkspaceRoot(arctgx#base#getBufferDirectory()),
      \ <bang>0,
      \ <f-args>,
      \ )

command! -bang -nargs=* GFBranch call arctgx#git#fzf#branch(
      \ arctgx#git#getWorkspaceRoot(arctgx#base#getBufferDirectory()),
      \ <bang>0,
      \ )

nmap <Plug>(ide-git-show-branches) <Cmd>GFBranch!<CR>
