function! arctgx#fzf#performActionOnLines(actionMap, actionName, lines) abort
  if !has_key(a:actionMap, a:actionName)
    echoerr printf('Action %s not supported\n', a:actionName)
    return
  endif

  let l:Action = a:actionMap[a:actionName]

  call l:Action(a:lines)
endfunction

function! arctgx#fzf#editLines(lines, command) abort
  if index(['edit', 'split', 'vsplit'], a:command) < 0
    throw 'Command not allowed'
  endif

  for l:line in a:lines
    execute a:command . ' ' . l:line.filename
    call s:goToLine(l:line)
  endfor
endfunction

function! arctgx#fzf#tabDropLines(lines) abort
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
  execute 'TabDrop ' . fnameescape(a:line.filename)

  call s:goToLine(a:line)
endfunction

function! s:goToLine(line) abort
  if !has_key(a:line, 'lineNumber')
    return
  endif

  if a:line.lineNumber =~# '\D'
    throw 'Expected line number'
  endif

  execute a:line.lineNumber
  if !empty(a:line.column)
    call cursor(0, str2nr(a:line.column))
  endif
  normal! zz
endfunction

function! arctgx#fzf#getActionFromKeyboardShortcut(shortcutMap, shortcut) abort
  if !has_key(a:shortcutMap, a:shortcut)
    echoerr printf('No action for "%s"', a:shortcut)

    return
  endif

  return a:shortcutMap[a:shortcut]
endfunction

function! arctgx#fzf#defaultActionMap() abort
  return {
        \ 'TabDrop': {lines -> arctgx#fzf#tabDropLines(lines)},
        \ 'edit': {lines -> arctgx#fzf#editLines(lines, 'edit')},
        \ 'split': {lines -> arctgx#fzf#editLines(lines, 'split')},
        \ 'vsplit': {lines -> arctgx#fzf#editLines(lines, 'vsplit')},
        \ }
endfunction

function! arctgx#fzf#openFzfSelection(Deserializer, ShortcutToAction, actionMap, lines) abort
  if len(a:lines) < 2
    return
  endif

  let l:keyboardShortcut = a:lines[0]

  let l:lines = map(filter(a:lines[1:], {line -> len(line)}), {idx, line -> a:Deserializer(line)})

  if empty(l:lines)
    return
  endif

  let l:action = a:ShortcutToAction(l:keyboardShortcut)

  call arctgx#fzf#performActionOnLines(a:actionMap, l:action, l:lines)
endfunction
