let g:fzf_history_dir = expand('~/.cache/fzf-history')
let g:fzf_action = {
      \ 'enter': 'tab drop',
      \ 'ctrl-y': 'edit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

nmap <Plug>(ide-browse-files) <Cmd>:Files<CR>
nmap <Plug>(ide-browse-gfiles) <Cmd>:GFiles<CR>

if has('nvim')
  nmap <Plug>(ide-browse-buffers) <Cmd>call fzf#vim#buffers({}, 0)<CR>
  nmap <Plug>(ide-browse-cmd-history) <Cmd>History:<CR>
  nmap <Plug>(ide-browse-history) <Cmd>call fzf#vim#history()<CR>
  nmap <Plug>(ide-browse-windows) <Cmd>call fzf#vim#windows()<CR>
  nmap <Plug>(ide-grep-git) <Cmd>:GGrep<CR>
  nmap <Plug>(ide-grep-files) <Cmd>:RGrep<CR>
else
  nmap <Plug>(ide-browse-buffers) :<C-U>call fzf#vim#buffers({}, 0)<CR>
  nmap <Plug>(ide-browse-cmd-history) :<C-U>History:<CR>
  nmap <Plug>(ide-browse-history) :<C-U>call fzf#vim#history()<CR>
  nmap <Plug>(ide-browse-windows) :<C-U>call fzf#vim#windows()<CR>
  nmap <Plug>(ide-grep-git) :<C-U>GGrep<CR>
  nmap <Plug>(ide-grep-files) :<C-U>RGrep<CR>
endif

command! -bang -nargs=* GGrep call s:ggrep(<q-args>, <bang>0)
command! -bang -nargs=* RGrep call s:rgrep(<q-args>, <bang>0)

function s:ggrep(query, fullscreen) abort
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

function s:rgrep(query, fullscreen) abort
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
