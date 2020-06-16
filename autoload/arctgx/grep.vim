function! arctgx#grep#grep(...)
  let l:params = copy(a:000)
  call map(l:params, 'shellescape(v:val)')
  let l:paramstring = join(l:params, ' ')

  let l:GrepCallback = get(g:, 'ArctgxGrepCallback', function('arctgx#grep#gnu'))
  call l:GrepCallback(l:paramstring)
endfunction

function! arctgx#grep#grepOperator(type)
  let l:saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  call arctgx#grep#grep(@@)

  let @@ = l:saved_unnamed_register
endfunction

function arctgx#grep#gnu(params)
  let l:params = '--recursive -- ' . a:params
  silent execute 'lgrep! ' . l:params . ' .'
  lopen
  let w:quickfix_title = 'grep: ' . l:params
endfunction

function arctgx#grep#ggrep(query, fullscreen) abort
  let l:bufdir = expand('%:p:h')
  let l:gitTopCmd = printf('git -C "%s" rev-parse --show-toplevel ', l:bufdir)
  let l:gitTop = systemlist(l:gitTopCmd)[0]
  if empty(l:gitTop)
    let l:gitTop = getcwd()
  endif

  call s:fzfVimGrep(
        \ l:gitTop,
        \ s:gitGrepCmd(l:gitTop, shellescape(a:query)),
        \ s:gitGrepCmd(l:gitTop, '{q}'),
        \ a:query,
        \ a:fullscreen
        \ )
endfunction

function arctgx#grep#rgrep(query, fullscreen) abort
  call s:fzfVimGrep(
        \ getcwd(),
        \ s:ripgrepCmd(shellescape(a:query)),
        \ s:ripgrepCmd('{q}'),
        \ a:query,
        \ a:fullscreen
        \ )
endfunction

function s:gitGrepCmd(topDir, query) abort
  return printf('git -C "%s" grep --line-number -- %s || true', a:topDir, a:query)
endfunction

function s:ripgrepCmd(query) abort
  return printf('rg --column --line-number --no-heading --color=always --smart-case %s', a:query)
endfunction

function s:fzfVimGrep(dir, initialCmd, reloadCmd, query, fullscreen) abort
  call fzf#vim#grep(a:initialCmd, 0, fzf#vim#with_preview({
        \ 'dir': a:dir,
        \ 'options': [
        \ '--phony',
        \ '--query', a:query,
        \ '--bind', 'change:reload:' . a:reloadCmd,
        \ ]
        \ }), a:fullscreen)
endfunction
