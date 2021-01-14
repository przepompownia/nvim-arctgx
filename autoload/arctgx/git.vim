function! arctgx#git#gitGetWorkspaceRoot(startDirectory) abort
  if !isdirectory(a:startDirectory)
    throw 'arctgx#git#gitGetWorkspaceRoot: invalid directory'
  endif

  let l:gitTopCmd = printf('git -C "%s" rev-parse --show-toplevel 2>/dev/null', a:startDirectory)
  let l:gitTopCmdResult = systemlist(l:gitTopCmd)
  if empty(l:gitTopCmdResult)
    echomsg printf('Git work tree root not found for %s. Searching within CWD.', a:startDirectory)
    return getcwd()
  endif

  return l:gitTopCmdResult[0]
endfunction
