function! arctgx#grep#getRipGrepCmd(query, useFixedStrings, ignoreCase) abort
  return printf(
        \ 'rg --column --line-number --column --no-heading --color=always --smart-case %s %s -- %s',
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
        \ 'git -C "%s" grep --line-number --column %s %s -- %s || true',
        \ arctgx#git#gitGetWorkspaceRoot(expand('%:p:h')),
        \ s:ignoreCaseDefaultString(a:ignoreCase),
        \ s:useFixedStringsDefaultString(a:useFixedStrings),
        \ a:query
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
        \ 0
        \ )
endfunction

function! arctgx#grep#gitGrepOperator(type) abort
  call arctgx#grep#grep(
        \ function('arctgx#grep#getGitGrepCmd'),
        \ arctgx#git#gitGetWorkspaceRoot(expand('%:p:h')),
        \ arctgx#operator#getText(a:type),
        \ v:true,
        \ v:false,
        \ 0
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

function! s:openGrepSelection(lines) abort
  if len(a:lines) < 2
    return
  endif

  let l:keyboardShortcut = a:lines[0]

  let l:lines = map(filter(a:lines[1:], {line -> len(line)}), {idx, line -> s:deserializeLine(line)})

  if empty(l:lines)
    return
  endif

  " todo support more actions
  let l:action = 'tab drop'

  call s:performActionOnLines(l:action, l:lines)
endfunction

function! s:performActionOnLines(action, lines) abort
  if a:action is# 'tab drop'
    call s:tabDropLines(a:lines)
    return
  endif

  for l:line in a:lines
  endfor
endfunction

function! s:tabDropLines(lines) abort
  let l:filesToOpen = {}
  for l:line in a:lines
    if has_key(l:filesToOpen, l:line.filename)
      continue
    endif

    let l:filesToOpen[l:line.filename] = l:line
  endfor

  for l:fn in keys(l:filesToOpen)
    call s:tabDropLine(l:filesToOpen[l:fn])
  endfor
endfunction

function! s:tabDropLine(line) abort
  execute 'tab drop ' . fnameescape(a:line.filename)

  execute a:line.lineNumber
  if !empty(a:line.column)
    call cursor(0, str2nr(a:line.column))
  endif
  normal! zz
endfunction

function! arctgx#grep#grep(Cmd, root, query, useFixedStrings, ignoreCase, fullscreen) abort
  let l:command = a:Cmd(shellescape(a:query), a:useFixedStrings, a:ignoreCase)
  let l:cmdShortName = split(l:command, '\s')[0]
  call fzf#vim#grep(l:command, 1, fzf#vim#with_preview({
        \ 'dir': a:root,
        \ 'sink*': function('s:openGrepSelection'),
        \ 'options': [
        \ '--phony',
        \ '--multi',
        \ '--query', a:query,
        \ '--prompt', s:prompt(l:cmdShortName, a:useFixedStrings),
        \ '--bind', 'change:reload:' . a:Cmd('{q}', a:useFixedStrings, a:ignoreCase),
        \ '--bind', 'alt-f:reload:' . a:Cmd('{q}', v:true, a:ignoreCase),
        \ '--bind', 'alt-f:+change-prompt:' . s:prompt(l:cmdShortName, v:true),
        \ '--bind', 'alt-r:reload:' . a:Cmd('{q}', v:false, a:ignoreCase),
        \ '--bind', 'alt-r:+change-prompt:' . s:prompt(l:cmdShortName, v:false),
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
