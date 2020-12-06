function! arctgx#grep#getRipGrepCmd(query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'rg --column --line-number --no-heading --color=always --smart-case %s %s -- %s',
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ a:query
        \ )
endfunction

function! arctgx#grep#getGnuGrepCmd(query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'grep --with-filename --extended-regexp --no-messages --color=never --binary-files=without-match --exclude-dir=.svn --exclude=tags --exclude=taglist.vim --exclude-dir=.git --line-number --recursive %s %s -- %s',
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query
        \ )
endfunction

function! arctgx#grep#getGitGrepCmd(query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'git -C "%s" grep --line-number %s %s -- %s || true',
        \ arctgx#grep#gitGetWorkspaceRoot(expand('%:p:h')),
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query
        \ )
endfunction

function! arctgx#grep#gitGetWorkspaceRoot(startDirectory) abort
  if !isdirectory(a:startDirectory)
    throw 'arctgx#grep#gitGetWorkspaceRoot: invalid directory'
  endif

  let l:gitTopCmd = printf('git -C "%s" rev-parse --show-toplevel 2>/dev/null', a:startDirectory)
  let l:gitTopCmdResult = systemlist(l:gitTopCmd)
  if empty(l:gitTopCmdResult)
    echomsg printf('Git work tree root not found for %s. Searching within CWD.', a:startDirectory)
    return getcwd()
  endif

  return l:gitTopCmdResult[0]
endfunction

function! arctgx#grep#grepOperator(type) abort
  let l:GetGrepCmd = get(g:, 'ArctgxGetGrepCmd', function('arctgx#grep#getRipGrepCmd'))

  call arctgx#grep#grep(
        \ l:GetGrepCmd,
        \ getcwd(),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ v:false,
        \ 0
        \ )
endfunction

function! arctgx#grep#gitGrepOperator(type) abort
  call arctgx#grep#grep(
        \ function('arctgx#grep#getGitGrepCmd'),
        \ arctgx#grep#gitGetWorkspaceRoot(expand('%:p:h')),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ v:false,
        \ 0
        \ )
endfunction

function! arctgx#grep#grep(Cmd, root, query, useFixedStrings, ignoreCase, fullscreen) abort
  let l:command = a:Cmd(shellescape(a:query), a:useFixedStrings, a:ignoreCase)
  let l:cmdShortName = split(l:command, '\s')[0]
  call fzf#vim#grep(l:command, 0, fzf#vim#with_preview({
        \ 'dir': a:root,
        \ 'options': [
        \ '--phony',
        \ '--multi',
        \ '--query', a:query,
        \ '--prompt', s:prompt(l:cmdShortName, a:useFixedStrings),
        \ '--bind', 'change:reload:' . a:Cmd('{q}', a:useFixedStrings, a:ignoreCase),
        \ '--bind', 'ctrl-f:reload:' . a:Cmd('{q}', v:true, a:ignoreCase),
        \ '--bind', 'ctrl-f:+change-prompt:' . s:prompt(l:cmdShortName, v:true),
        \ '--bind', 'ctrl-r:reload:' . a:Cmd('{q}', v:false, a:ignoreCase),
        \ '--bind', 'ctrl-r:+change-prompt:' . s:prompt(l:cmdShortName, v:false),
        \ ]
        \ }), a:fullscreen)
endfunction

function s:prompt(cmd, useFixedStrings) abort
  let l:fixedStrings = (v:true is a:useFixedStrings) ? 'fixed strings' : 'regexp'

  return printf('%s (%s): > ', a:cmd, l:fixedStrings)
endfunction

function! s:useFixedStringsDefaultString(useFixedStrings) abort
  return (a:useFixedStrings is v:true) ? ' --fixed-strings' : ''
endfunction

function! s:ignoreCaseDefaultString(ignoreCase) abort
  return (a:ignoreCase is v:true) ? ' --ignore-case' : ''
endfunction
