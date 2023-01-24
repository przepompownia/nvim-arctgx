let s:binDir = simplify(expand('<sfile>:p:h') . '/../../bin')

function! arctgx#git#getWorkspaceRoot(startDirectory) abort
  try
    return arctgx#git#getToplevelDirectory(a:startDirectory)
  catch /^Git toplevel not found for .*/
    echomsg printf('%s Using current working dir.', v:exception)
    return getcwd()
  endtry
endfunction

function! arctgx#git#getToplevelDirectory(startDirectory) abort
  if !isdirectory(a:startDirectory)
    throw 'arctgx#git#getWorkspaceRoot: invalid directory'
  endif

  let l:gitTopCmd = printf('git -C "%s" rev-parse --show-toplevel 2>/dev/null', a:startDirectory)
  let l:gitTopCmdResult = systemlist(l:gitTopCmd)
  if empty(l:gitTopCmdResult)
    throw printf('Git toplevel not found for %s.', a:startDirectory)
  endif

  return l:gitTopCmdResult[0]
endfunction

function! arctgx#git#listBranches(gitDir, withRelativeDate) abort
  let l:initialCmd = [s:binDir . '/git-list-branches', a:gitDir]

  if a:withRelativeDate isnot v:true
    call add(l:initialCmd, 1)
  endif

  return systemlist(l:initialCmd)
endfunction
