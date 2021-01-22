function! arctgx#git#fzf#serializeGFDiffCommand(cmd) abort
  return printf(
        \ 'git diff --relative %s %s %s %s',
        \ (a:cmd.query.value is v:null) ? '' : printf('%s %s', a:cmd.query.type, a:cmd.query.value),
        \ join(a:cmd.options, ' '),
        \ join(a:cmd.commits, ' '),
        \ s:createPathString(join(a:cmd.paths, ' '))
        \ )
endfunction

function! s:createPathString(path) abort
  if len(a:path)
    return '-- ' . a:path
  endif

  return ''
endfunction

function! arctgx#git#fzf#diff(CmdSerializer, dir, fullscreen, ...) abort
  let l:cmd = arctgx#git#parseGFDiffCommandArguments(a:000)
  let l:previewCmd = deepcopy(l:cmd)

  call add(l:cmd.options, '--name-only')
  echom a:CmdSerializer(l:previewCmd)
  let l:interactiveCmd = deepcopy(l:cmd)
  let l:interactiveCmd.query.value = '{q}'

  let l:previewCmd.paths = ['{}']
  let l:previewCmd.query.value = '{q}'

  let l:initialCmdString = a:CmdSerializer(l:cmd)

  call fzf#run(fzf#wrap({
        \ 'source': l:initialCmdString,
        \ 'sink': 'tab drop',
        \ 'dir': a:dir,
        \ 'options': [
          \ '--multi',
          \ '--disabled',
          \ '--query', l:cmd.query.value,
          \ '--prompt', a:CmdSerializer(l:interactiveCmd) . '> ',
          \ '--bind', 'change:reload:' . a:CmdSerializer(l:interactiveCmd),
          \ '--bind', 'alt-s:toggle-search',
          \ '--preview',
          \ a:CmdSerializer(l:previewCmd) . ' | delta --width ${FZF_PREVIEW_COLUMNS:-$COLUMNS} --file-style=omit | sed 1d',
          \ ]
        \ }), a:fullscreen)
endfunction
