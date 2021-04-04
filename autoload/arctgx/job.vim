function! s:echoMessage(message, level) abort
  if empty(a:message)
    return
  endif

  if ('error' is a:level)
    echoerr a:message

    return
  endif

  echomsg a:message
endfunction

function! s:outputHandler(level, params, jobId, stdOut, ...) abort
  call s:displayOutput(a:stdOut, a:level)
endfunction

function! s:displayOutput(stdOut, level) abort
  if type(a:stdOut) is v:t_string
    call s:echoMessage(a:stdOut, a:level)

    return
  endif

  if type(a:stdOut) is v:t_list
    for l:message in a:stdOut
      call s:echoMessage(l:message, a:level)
    endfor
  endif
endfunction

function! arctgx#job#executeCommand(command, params, stdoutHandler, exitHandler, errorHandler) abort
  let l:nv = has('nvim')
  let l:JobStart = l:nv ? function('jobstart') : function('job_start')
  let l:onStdout = l:nv ? 'on_stdout' : 'out_cb'
  let l:onExit = l:nv ? 'on_exit' : 'exit_cb'
  let l:onError = l:nv ? 'on_stderr' : 'err_cb'

  let l:options = {}

  if (has_key(a:params, 'cwd') && !empty(a:params.cwd))
    if ! isdirectory(a:params.cwd)
      throw printf('Directory does not exist (%s)', a:params.cwd)
    endif

    let l:options['cwd'] = a:params.cwd
  endif

  let l:StdoutHandler = (v:null is a:stdoutHandler) ? function('s:outputHandler', ['info']) : a:stdoutHandler
  let l:ErrorHandler = (v:null is a:errorHandler) ? function('s:outputHandler', ['error']) : a:errorHandler

  let l:options[l:onStdout] = function(l:StdoutHandler, [a:params])
  let l:options[l:onExit] = function(a:exitHandler, [a:params])
  let l:options[l:onError] = function(l:ErrorHandler, [a:params])

  let l:jobId = l:JobStart(a:command, l:options)

  return l:jobId
endfunction

