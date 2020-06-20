function arctgx#grep#getRipGrepCmd(query, useFixedStrings) abort
  let l:fixedStringOption = (a:useFixedStrings is v:true) ? ' --fixed-strings' : ''
  return printf('rg --column --line-number --no-heading --color=always --smart-case %s %s', l:fixedStringOption, a:query)
endfunction

function arctgx#grep#getGnuGrepCmd(query, useFixedStrings)
  let l:fixedStringOption = (a:useFixedStrings is v:true) ? ' --fixed-strings' : ''

  return printf(
        \ 'grep --with-filename --extended-regexp --no-messages --color=never --binary-files=without-match --exclude-dir=.svn --exclude=tags --exclude=taglist.vim --exclude-dir=.git --line-number --recursive %s %s',
        \ l:fixedStringOption,
        \ a:query
        \ )
endfunction

function arctgx#grep#getGitGrepCmd(query, useFixedStrings) abort
  let l:fixedStringOption = (a:useFixedStrings is v:true) ? ' --fixed-strings' : ''

  return printf(
        \ 'git -C "%s" grep --line-number %s -- %s || true',
        \ arctgx#grep#gitGetWorkspaceRoot(),
        \ l:fixedStringOption,
        \ a:query
        \ )
endfunction

function arctgx#grep#gitGetWorkspaceRoot() abort
  let l:bufdir = expand('%:p:h')
  let l:gitTopCmd = printf('git -C "%s" rev-parse --show-toplevel ', l:bufdir)
  let l:gitTop = systemlist(l:gitTopCmd)[0]
  if ! empty(l:gitTop)
    return l:gitTop
  endif

  echomsg printf('Git work tree root not found for %s. Searching within CWD.', l:bufdir)
  return getcwd()
endfunction

function! arctgx#grep#grepOperator(type)
  let l:GetGrepCmd = get(g:, 'ArctgxGetGrepCmd', function('arctgx#grep#getRipGrepCmd'))

  call arctgx#grep#grep(
        \ l:GetGrepCmd,
        \ getcwd(),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ 0
        \ )
endfunction

function! arctgx#grep#gitGrepOperator(type)
  call arctgx#grep#grep(
        \ function('arctgx#grep#getGitGrepCmd'),
        \ arctgx#grep#gitGetWorkspaceRoot(),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ 0
        \ )
endfunction

function arctgx#grep#grep(Cmd, root, query, useFixedStrings, fullscreen) abort
  call fzf#vim#grep(a:Cmd(a:query, a:useFixedStrings), 0, fzf#vim#with_preview({
        \ 'dir': a:root,
        \ 'options': [
        \ '--phony',
        \ '--query', a:query,
        \ '--bind', 'change:reload:' . a:Cmd('{q}', a:useFixedStrings),
        \ ]
        \ }), a:fullscreen)
endfunction
