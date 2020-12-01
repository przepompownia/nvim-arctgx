function! arctgx#grep#getRipGrepCmd(query, useFixedStrings) abort
  return printf(
        \ 'rg --column --line-number --no-heading --color=always --smart-case %s %s',
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query
        \ )
endfunction

function! arctgx#grep#getGnuGrepCmd(query, useFixedStrings) abort
  return printf(
        \ 'grep --with-filename --extended-regexp --no-messages --color=never --binary-files=without-match --exclude-dir=.svn --exclude=tags --exclude=taglist.vim --exclude-dir=.git --line-number --recursive %s %s',
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query
        \ )
endfunction

function! arctgx#grep#getGitGrepCmd(query, useFixedStrings) abort
  return printf(
        \ 'git -C "%s" grep --line-number %s -- %s || true',
        \ arctgx#grep#gitGetWorkspaceRoot(expand('%:p:h')),
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
        \ 0
        \ )
endfunction

function! arctgx#grep#gitGrepOperator(type) abort
  call arctgx#grep#grep(
        \ function('arctgx#grep#getGitGrepCmd'),
        \ arctgx#grep#gitGetWorkspaceRoot(expand('%:p:h')),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ 0
        \ )
endfunction

function! arctgx#grep#grep(Cmd, root, query, useFixedStrings, fullscreen) abort
  call fzf#vim#grep(a:Cmd(shellescape(a:query), a:useFixedStrings), 0, fzf#vim#with_preview({
        \ 'dir': a:root,
        \ 'options': [
        \ '--phony',
        \ '--multi',
        \ '--query', a:query,
        \ '--bind', 'change:reload:' . a:Cmd('{q}', a:useFixedStrings),
        \ '--bind', 'ctrl-f:reload:' . a:Cmd('{q}', v:true),
        \ '--bind', 'ctrl-r:reload:' . a:Cmd('{q}', v:false),
        \ ]
        \ }), a:fullscreen)
endfunction

function! s:useFixedStringsDefaultString(useFixedStrings) abort
  return (a:useFixedStrings is v:true) ? ' --fixed-strings' : ''
endfunction
