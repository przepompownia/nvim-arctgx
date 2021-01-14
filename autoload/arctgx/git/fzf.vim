function! arctgx#git#fzf#gregex(commits, query, path, ...) abort
  let l:args = join(a:000, ' ')

  return printf(
        \ 'git diff --relative %s %s %s %s',
        \ s:createGQueryString(a:query),
        \ l:args,
        \ a:commits,
        \ s:createPathString(a:path)
        \ )
endfunction

function s:createPathString(path) abort
  if len(a:path)
    return ' -- ' . a:path
  endif

  return ''
endfunction

function s:createGQueryString(query) abort
  if len(a:query)
    return '-G ' . a:query
  endif

  return ''
endfunction

function! arctgx#git#fzf#diff(Cmd, dir, commits, query, fullscreen) abort
  let l:command = a:Cmd(a:commits, len(a:query) ? shellescape(a:query) : '', '', '--name-only')
  echom l:command
  call fzf#run(fzf#wrap({
        \ 'source': l:command,
        \ 'sink': 'tab drop',
        \ 'dir': a:dir,
        \ 'options': [
          \ '--multi',
          \ '--disabled',
          \ '--prompt', a:Cmd(a:commits, '{q}', '', '--name-only') . '> ',
          \ '--bind', 'change:reload:' . a:Cmd(a:commits, '{q}', '', '--name-only'),
          \ '--bind', 'alt-s:toggle-search',
          \ '--preview',
          \ a:Cmd(a:commits, '', '{}') . ' | delta --width ${FZF_PREVIEW_COLUMNS:-$COLUMNS} --file-style=omit | sed 1d',
          \ ]
        \ }), a:fullscreen)
endfunction
