let g:fzf_history_dir = expand('~/.cache/fzf-history')
call setenv('DELTA_FEATURES', 'fzf')
let g:fzf_preview_window = ['up:70%', 'ctrl-/']
let g:fzf_action = {
      \ 'enter': 'TabDrop',
      \ 'ctrl-y': 'edit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:fzf_git_buffer_relative_root = 1

command! -bang -nargs=* FzfGGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getGitGrepCmd'),
      \ arctgx#git#getWorkspaceRoot(arctgx#base#getBufferDirectory()),
      \ <q-args>,
      \ v:false,
      \ v:false,
      \ <bang>0,
      \ )
command! -bang -nargs=* FzfRGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getRipGrepCmd'),
      \ getcwd(),
      \ <q-args>,
      \ v:false,
      \ v:false,
      \ <bang>0
      \ )

nmap <Plug>(ide-browse-buffers) <Cmd>call fzf#vim#buffers({}, 0)<CR>
nmap <Plug>(ide-browse-history) <Cmd>call fzf#vim#history(fzf#vim#with_preview(), 1)<CR>
nmap <Plug>(ide-browse-windows) <Cmd>call fzf#vim#windows()<CR>

" nmap <Plug>(ide-browse-cmd-history) <Cmd>History:<CR>
" nmap <Plug>(ide-browse-files) <Cmd>Files!<CR>
" nmap <Plug>(ide-browse-gfiles) <Cmd>GFiles!<CR>
