scriptencoding utf-8

function arctgx#ide#bufname() abort
  return bufname()
endfunction

function arctgx#ide#get_current_git_head() abort
  let l:head = get(b:, 'ide_current_git_head', '')

  if empty(l:head)
    return ''
  endif

  return printf('%s', l:funcname)
endfunction

function arctgx#ide#get_current_function() abort
  let l:funcname = get(b:, 'ide_current_function', '')

  if empty(l:funcname)
    return ''
  endif

  return printf('[::%s]', l:funcname)
endfunction

function arctgx#ide#showLocation() abort
  return arctgx#ide#bufname() . arctgx#ide#get_current_function()
endfunction

function arctgx#ide#showGitBranch() abort
  return arctgx#string#shorten(FugitiveHead())
endfunction

function arctgx#ide#showIsLastUsedWindow() abort
  return winnr() is winnr("#") ? ' [LW]' : ''
endfunction

function arctgx#ide#showWinInfo() abort
  return printf(
        \ 'b:%d, tw: %d.%d (%d)%s',
        \ bufnr(),
        \ tabpagenr(),
        \ winnr(),
        \ win_getid(),
        \ arctgx#ide#showIsLastUsedWindow(),
        \ )
endfunction

function arctgx#ide#displayFileNameInTab(tabNumber) abort
  let buflist = tabpagebuflist(a:tabNumber)
  let winnr = tabpagewinnr(a:tabNumber)
  let _ = expand('#'.buflist[winnr - 1].':p:t:r')

  return _ !=# '' ? _ : '[No Name]'
endfunction

function arctgx#ide#showGitHead() abort
  let l:command = ['git', 'symbolic-ref', '--quiet', '--short', 'HEAD']
  call arctgx#ide#executeCommand(l:command, 's:handleGitHeadOutput', 's:handleSymbolicRefExitCode')
endfunction

function s:handleGitHeadOutput(jobId, data, event)
  if empty(a:data)
    return
  endif

  let b:ide_current_git_head = join(a:data)
endfunction

function s:handleSymbolicRefExitCode(jobId, data, event)
  let l:exitCode = a:data

  if (0 == l:exitCode)
    return
  endif

  let l:command = ['git', 'show-ref', '--hash', '--head', '--abbrev', '^HEAD']

  call arctgx#ide#executeCommand(l:command, 's:handleGitHeadOutput', 's:handleShowRefExitCode')
endfunction

function s:handleShowRefExitCode(jobId, data, event)
  let l:exitCode = a:data

  if (0 == l:exitCode)
    return
  endif

  let b:ide_current_git_head = 'fallback ref'
endfunction

function arctgx#ide#executeCommand(command, stdoutHandler, exitHandler) abort
  let l:options = {
        \ 'on_stdout': function(a:stdoutHandler),
        \ 'on_exit': function(a:exitHandler),
        \ 'stdout_buffered': 1,
        \ }

  let job = jobstart(a:command, l:options)
endfunction
