function! arctgx#git#getWorkspaceRoot(startDirectory) abort
  if !isdirectory(a:startDirectory)
    throw 'arctgx#git#getWorkspaceRoot: invalid directory'
  endif

  let l:gitTopCmd = printf('git -C "%s" rev-parse --show-toplevel 2>/dev/null', a:startDirectory)
  let l:gitTopCmdResult = systemlist(l:gitTopCmd)
  if empty(l:gitTopCmdResult)
    echomsg printf('Git work tree root not found for %s. Searching within CWD.', a:startDirectory)
    return getcwd()
  endif

  return l:gitTopCmdResult[0]
endfunction

""
"
" commitspecs -- options -- paths
function! arctgx#git#parseGFDiffCommandArguments(argList) abort
  let l:cmd = {
        \ 'commits': [],
        \ 'options': [],
        \ 'paths': [],
        \ 'query': {'type': '-G', 'value': v:null}
        \ }
  let l:cmdParts = ['commits', 'options', 'paths']
  let l:partIdx = 0
  let l:queryType = v:null

  for l:arg in a:argList
    if l:arg is# '--'
      if l:partIdx < len(l:cmdParts) - 1
        let l:partIdx = l:partIdx + 1
      endif
      continue
    endif

    if v:null isnot l:queryType && 'options' is# l:cmdParts[l:partIdx]
      let l:cmd.query.type = l:queryType
      let l:cmd.query.value = l:arg
      let l:queryType = v:null
      continue
    endif

    if l:arg is# '-G' || l:arg is# '-S'
      let l:queryType = l:arg
      continue
    endif

    call add(l:cmd[l:cmdParts[l:partIdx]], l:arg)
  endfor

  return l:cmd
endfunction
