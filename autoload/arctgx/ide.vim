scriptencoding utf-8

function! arctgx#ide#bufname() abort
  return bufname()
endfunction

function! arctgx#ide#getCurrentGitHead() abort
  let l:head = get(b:, 'ideCurrentGitHead', '')

  if empty(l:head)
    return ''
  endif

  return printf('%s', arctgx#string#shorten(l:head, 11))
endfunction

function! s:setIdeCurrentGitHead(bufnr, value) abort
  call setbufvar(a:bufnr, 'ideCurrentGitHead', a:value)

  doautocmd <nomodeline> User IdeStatusChanged
endfunction

function! arctgx#ide#getCurrentFunction() abort
  let l:funcname = get(b:, 'ideCurrentFunction', '')

  if empty(l:funcname)
    return ''
  endif

  return printf('[::%s]', l:funcname)
endfunction

function! arctgx#ide#showLocation() abort
  return arctgx#ide#bufname() . arctgx#ide#getCurrentFunction()
endfunction

function! arctgx#ide#showIsLastUsedWindow() abort
  return winnr() is winnr('#') ? ' [LW]' : ''
endfunction

function! arctgx#ide#showWinInfo() abort
  return printf(
        \ 'b:%d, tw: %d.%d (%d)%s',
        \ bufnr(),
        \ tabpagenr(),
        \ winnr(),
        \ win_getid(),
        \ len(tabpagebuflist(tabpagenr())) > 1 ? arctgx#ide#showIsLastUsedWindow() : '',
        \ )
endfunction

function! arctgx#ide#displayFileNameInTab(tabNumber) abort
  let l:buflist = tabpagebuflist(a:tabNumber)
  let l:winnr = tabpagewinnr(a:tabNumber)
  let l:output = expand('#'.l:buflist[l:winnr - 1].':p:t:r')

  return l:output !=# '' ? arctgx#string#shorten(l:output, 8) : '[No Name]'
endfunction

function! arctgx#ide#recognizeGitHeadsInTab() abort
  let l:tabBufNumbers = tabpagebuflist()

  for l:bufnr in l:tabBufNumbers
    call arctgx#ide#recognizeGitHead(l:bufnr)
  endfor
endfunction

" vint: next-line -ProhibitUnusedVariable
function! arctgx#ide#recognizeGitHead(bufnr) abort
  let l:directory = fnamemodify(bufname(str2nr(a:bufnr)), ':p:h')
  if !isdirectory(l:directory)
    return
  endif

  let l:command = ['git', 'symbolic-ref', '--quiet', '--short', 'HEAD']
  let l:params = {'bufnr': a:bufnr, 'cwd': l:directory}

  call arctgx#ide#executeCommand(l:command, l:params, 's:handleGitHeadOutput', 's:handleSymbolicRefExitCode')
endfunction

function! s:handleGitHeadOutput(params, jobId, stdOut, ...) abort
  let l:output = type(a:stdOut) is v:t_list ? join(a:stdOut) : a:stdOut

  if empty(l:output)
    return
  endif

  call s:setIdeCurrentGitHead(a:params.bufnr, l:output)
endfunction

function! s:handleSymbolicRefExitCode(params, jobId, exitCode, ...) abort
  if (0 == a:exitCode)
    return
  endif

  let l:command = ['git', 'show-ref', '--hash', '--head', '--abbrev', '^HEAD']

  call arctgx#ide#executeCommand(l:command, a:params, 's:handleGitHeadOutput', 's:handleShowRefExitCode')
endfunction

function! s:handleShowRefExitCode(params, jobId, data, ...) abort
  let l:exitCode = a:data

  if (0 == l:exitCode)
    return
  endif

  call s:setIdeCurrentGitHead(a:params.bufnr, '')
endfunction

function! arctgx#ide#executeCommand(command, params, stdoutHandler, exitHandler) abort
  let l:nv = has('nvim')
  let l:JobStart = l:nv ? function('jobstart') : function('job_start')
  let l:onStdout = l:nv ? 'on_stdout' : 'out_cb'
  let l:onExit = l:nv ? 'on_exit' : 'exit_cb'

  let l:options = {}

  if (has_key(a:params, 'cwd') && !empty(a:params.cwd))
    if ! isdirectory(a:params.cwd)
      throw printf('Directory does not exist (%s)', a:params.cwd)
    endif

    let l:options['cwd'] = a:params.cwd
  endif

  let l:options[l:onStdout] = function(a:stdoutHandler, [a:params])
  let l:options[l:onExit] = function(a:exitHandler, [a:params])

  let l:jobId = l:JobStart(a:command, l:options)

  return l:jobId
endfunction
