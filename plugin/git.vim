command! -bang -nargs=+ -complete=customlist,s:completeGFDiff GFDiff call arctgx#git#fzf#diff(
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
vmap <Plug>(ide-git-files-search-operator) :<C-U>call arctgx#git#findFileOperator(visualmode())<CR>
nmap <Plug>(ide-git-files-search-operator) :set operatorfunc=arctgx#git#findFileOperator<CR>g@

function! s:completeGFDiff(ArgLead, CmdLine, CursorPos) abort
  let l:gitDir = arctgx#git#getWorkspaceRoot(expand('%:p:h'))
  return reverse(arctgx#git#listBranches(l:gitDir, v:false))
endfunction
