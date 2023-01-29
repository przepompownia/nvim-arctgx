scriptencoding utf-8

function! arctgx#ide#getCurrentGitHead() abort
  let l:head = get(b:, 'ideCurrentGitHead', '')

  if empty(l:head)
    return ''
  endif

  return printf('%s', arctgx#string#shorten(pathshorten(l:head), 11))
endfunction

function! s:setIdeCurrentGitHead(bufnr, value) abort
  call setbufvar(a:bufnr, 'ideCurrentGitHead', a:value)

  doautocmd <nomodeline> User IdeStatusChanged
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
  let l:bufnr = l:buflist[l:winnr - 1]

  return getbufvar(l:bufnr, 'ideTabName', arctgx#ide#createDefaultTabname(l:bufnr))
endfunction

function! arctgx#ide#createDefaultTabname(bufnr) abort
  let l:bufname = expand('#'. a:bufnr .':p:t:r')

  return l:bufname !=# '' ? arctgx#string#shorten(l:bufname, 8) : '[No Name]'
endfunction

function! arctgx#ide#recognizeGitHeadsInTab() abort
  let l:tabBufNumbers = tabpagebuflist()

  for l:bufnr in l:tabBufNumbers
    call arctgx#ide#recognizeGitHead(l:bufnr)
  endfor
endfunction

" vint: next-line -ProhibitUnusedVariable
function! arctgx#ide#recognizeGitHead(bufnr) abort
  if !empty(getbufvar(a:bufnr, '&buftype'))
    return
  endif

  let l:directory = fnamemodify(bufname(str2nr(a:bufnr)), ':p:h')
  if !isdirectory(l:directory)
    return
  endif

  let l:command = ['git', 'symbolic-ref', '--quiet', '--short', 'HEAD']
  let l:params = {'bufnr': a:bufnr, 'cwd': l:directory}

  call arctgx#job#executeCommand(
        \ l:command,
        \ l:params,
        \ function('s:handleGitHeadOutput'),
        \ function('s:handleSymbolicRefExitCode'),
        \ function('s:errorHandler'),
        \ )
endfunction

function! s:errorHandler(params, jobId, output, ...) abort
  return v:null
endfunction

function! s:handleGitHeadOutput(params, jobId, stdOut, ...) abort
  let l:output = type(a:stdOut) is v:t_list ? join(a:stdOut) : a:stdOut

  if empty(l:output)
    return
  endif

  call s:setIdeCurrentGitHead(a:params.bufnr, l:output)
endfunction

function! s:handleSymbolicRefExitCode(params, jobId, exitCode, ...) abort
  if (0 == a:exitCode || 128 == a:exitCode)
    return
  endif

  let l:command = ['git', 'show-ref', '--hash', '--head', '--abbrev', '^HEAD']

  call arctgx#job#executeCommand(
        \ l:command,
        \ a:params,
        \ function('s:handleGitHeadOutput'),
        \ function('s:handleShowRefExitCode'),
        \ function('s:errorHandler'),
        \ )
endfunction

function! s:handleShowRefExitCode(params, jobId, data, ...) abort
  let l:exitCode = a:data

  if (0 == l:exitCode)
    return
  endif

  call s:setIdeCurrentGitHead(a:params.bufnr, '')
endfunction
