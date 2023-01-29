let s:binDir = simplify(expand('<sfile>:p:h') . '/../../bin')

function! arctgx#git#listBranches(gitDir, withRelativeDate) abort
  let l:initialCmd = [s:binDir . '/git-list-branches', a:gitDir]

  if a:withRelativeDate isnot v:true
    call add(l:initialCmd, 1)
  endif

  return systemlist(l:initialCmd)
endfunction
