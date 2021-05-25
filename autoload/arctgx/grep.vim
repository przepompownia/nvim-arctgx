function! arctgx#grep#getRipGrepCmd(root, query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'rg --column --line-number --column --no-heading --color=never --smart-case %s %s -- %s %s',
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ a:query,
        \ a:root,
        \ )
endfunction

function! arctgx#grep#getGnuGrepCmd(root, query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'grep --with-filename --extended-regexp --no-messages --color=never --binary-files=without-match --exclude-dir=.svn --exclude=tags --exclude=taglist.vim --exclude-dir=.git --line-number --recursive %s %s -- %s %s',
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query,
        \ a:root,
        \ )
endfunction

function! arctgx#grep#getGitGrepCmd(root, query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'git grep --color=never --line-number --column %s %s -- %s || true',
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query,
        \ )
endfunction

function! arctgx#grep#grepOperator(type) abort
  let l:GetGrepCmd = get(g:, 'ArctgxGetGrepCmd', function('arctgx#grep#getRipGrepCmd'))

  call arctgx#grep#grep(
        \ l:GetGrepCmd,
        \ getcwd(),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ v:false,
        \ 1
        \ )
endfunction

function! arctgx#grep#gitGrepOperator(type) abort
  call arctgx#grep#grep(
        \ function('arctgx#grep#getGitGrepCmd'),
        \ arctgx#git#getWorkspaceRoot(expand('%:p:h')),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ v:false,
        \ 1
        \ )
endfunction

function! s:deserializeLine(line) abort
  " stolen from fzf.vim
  let l:parts = matchlist(a:line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')

  return {
        \ 'filename': &autochdir ? fnamemodify(l:parts[1], ':p') : l:parts[1],
        \ 'lineNumber': l:parts[2],
        \ 'text': l:parts[4],
        \ 'column': l:parts[3]
        \ }
endfunction

function! arctgx#grep#grep(Cmd, root, query, useFixedStrings, ignoreCase, fullscreen) abort
  let l:queryRoot = fnamemodify(a:root, ':p:.')
  let l:command = a:Cmd(l:queryRoot, shellescape(a:query), a:useFixedStrings, a:ignoreCase)
  let l:cmdShortName = split(l:command, '\s')[0]
  call fzf#vim#grep(l:command, 1, fzf#vim#with_preview({
        \ 'dir': a:root,
        \ 'sink*': function('arctgx#fzf#openFzfSelection', [
          \ function('s:deserializeLine'),
          \ function('arctgx#fzf#getActionFromKeyboardShortcut', [g:fzf_action]),
          \ arctgx#fzf#defaultActionMap()
        \ ]),
        \ 'options': [
          \ '--disabled',
          \ '--multi',
          \ '--prompt', s:prompt(l:cmdShortName, a:useFixedStrings),
          \ '--query', a:query,
          \ '--bind', 'change:reload:' . a:Cmd(l:queryRoot, '{q}', a:useFixedStrings, a:ignoreCase),
          \ '--bind', 'alt-f:reload:' . a:Cmd(l:queryRoot, '{q}', v:true, a:ignoreCase),
          \ '--bind', 'alt-f:+change-prompt:' . s:prompt(l:cmdShortName, v:true),
          \ '--bind', 'alt-r:reload:' . a:Cmd(l:queryRoot, '{q}', v:false, a:ignoreCase),
          \ '--bind', 'alt-r:+change-prompt:' . s:prompt(l:cmdShortName, v:false),
          \ '--bind', 'alt-s:unbind(change,alt-s)+change-prompt(FZF search: )+enable-search+clear-query',
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
