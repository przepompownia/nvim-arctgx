command! -bang -nargs=+ -complete=customlist,s:completeGFDiff GFDiff call arctgx#git#fzf#diff(
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

function! s:completeGFDiff(argLead, CmdLine, CursorPos) abort
  let l:gitDir = arctgx#git#getWorkspaceRoot(expand('%:p:h'))
  let l:branches = reverse(arctgx#git#listBranches(l:gitDir, v:false))
  let l:parts = s:split(a:argLead)

  let l:reducedList = filter(l:branches, {index, string -> stridx(string, l:parts.pattern) >= 0})

  return map(l:reducedList, {index, branch -> l:parts.lead .. branch})
endfunction

function! s:split(range) abort
  let l:separators = {
        \ '..': '\.\.',
        \ '...': '\.\.\.'
        \ }

  for l:separator in keys(l:separators)
    if stridx(a:range, l:separator) < 0
      continue
    endif
    let [l:lead, l:pattern] = split(a:range, l:separators[l:separator], 1)

    return #{
          \ lead: l:lead .. l:separator,
          \ pattern: l:pattern,
          \ }
  endfor

  return #{lead: '', pattern: a:range}
endfunction
