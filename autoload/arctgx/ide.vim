scriptencoding utf-8

function arctgx#ide#bufname() abort
  return bufname()
endfunction

function arctgx#ide#getCurrentGitHead() abort
  let l:head = get(b:, 'ideCurrentGitHead', '')

  if empty(l:head)
    return ''
  endif

  return printf('%s', arctgx#string#shorten(l:head))
endfunction

function arctgx#ide#getCurrentFunction() abort
  let l:funcname = get(b:, 'ide_current_function', '')

  if empty(l:funcname)
    return ''
  endif

  return printf('[::%s]', l:funcname)
endfunction

function arctgx#ide#showLocation() abort
  return arctgx#ide#bufname() . arctgx#ide#getCurrentFunction()
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
        \ len(tabpagebuflist(tabpagenr())) > 1 ? arctgx#ide#showIsLastUsedWindow() : '',
        \ )
endfunction

function arctgx#ide#displayFileNameInTab(tabNumber) abort
  let buflist = tabpagebuflist(a:tabNumber)
  let winnr = tabpagewinnr(a:tabNumber)
  let _ = expand('#'.buflist[winnr - 1].':p:t:r')

  return _ !=# '' ? _ : '[No Name]'
endfunction

function arctgx#ide#recognizeGitHead(filename) abort
  let l:directory = fnamemodify(a:filename, ':p:h')
  if !isdirectory(l:directory)
    return
  endif

  let l:command = ['git', '-C', l:directory, 'rev-parse', '--show-toplevel']

  call arctgx#ide#executeCommand(l:command, l:directory, 's:handleGitToplevelOutput', 's:handleSymbolicRefExitCode')
endfunction

function s:handleGitToplevelOutput(cwd, jobId, stdOut, ...)
  let l:toplevel = trim(type(a:stdOut) is v:t_list ? join(a:stdOut) : a:stdOut)

  if empty(l:toplevel)
    return
  endif

  let l:command = ['git', 'symbolic-ref', '--quiet', '--short', 'HEAD']
  call arctgx#ide#executeCommand(l:command, l:toplevel, 's:handleGitHeadOutput', 's:handleSymbolicRefExitCode')
endfunction

function s:handleGitHeadOutput(cwd, jobId, stdOut, ...)
  let l:output = type(a:stdOut) is v:t_list ? join(a:stdOut) : a:stdOut

  if empty(l:output)
    return
  endif

  let b:ideCurrentGitHead = l:output
endfunction

function s:handleSymbolicRefExitCode(cwd, jobId, exitCode, ...) abort
  if (0 == a:exitCode)
    return
  endif

  let l:command = ['git', 'show-ref', '--hash', '--head', '--abbrev', '^HEAD']

  call arctgx#ide#executeCommand(l:command, a:cwd, 's:handleGitHeadOutput', 's:handleShowRefExitCode')
endfunction

function s:handleShowRefExitCode(cwd, jobId, data, ...) abort
  let l:exitCode = a:data

  if (0 == l:exitCode)
    return
  endif

  let b:ideCurrentGitHead = ''
endfunction

function arctgx#ide#executeCommand(command, cwd, stdoutHandler, exitHandler) abort
  let l:nv = has('nvim')
  let l:JobStart = l:nv ? function('jobstart') : function('job_start')
  let l:onStdout = l:nv ? 'on_stdout' : 'out_cb'
  let l:onExit = l:nv ? 'on_exit' : 'exit_cb'

  let l:options = {}

  if (!empty(a:cwd))
    if ! isdirectory(a:cwd)
      throw printf('Directory does not exist (%s)', a:cwd)
    endif

    let l:options['cwd'] = a:cwd
  endif
  let l:options[l:onStdout] = function(a:stdoutHandler, [a:cwd])
  let l:options[l:onExit] = function(a:exitHandler, [a:cwd])

  let job = l:JobStart(a:command, l:options)
endfunction
