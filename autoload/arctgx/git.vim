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

function! arctgx#git#findFileOperator(type) abort
  let l:query = arctgx#operator#getText(a:type)
  call fzf#vim#gitfiles('', fzf#vim#with_preview({'options': ['--query', l:query]}), 1)
endfunction
