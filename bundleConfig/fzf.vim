let g:fzf_history_dir = expand('~/.cache/fzf-history')
let g:fzf_action = {
      \ 'enter': 'tab drop',
      \ 'ctrl-y': 'edit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

if has('nvim')
  nmap <Plug>(ide-browse-files) <Cmd>Files<CR>
  nmap <Plug>(ide-browse-gfiles) <Cmd>GFiles<CR>
  nmap <Plug>(ide-browse-buffers) <Cmd>call fzf#vim#buffers({}, 0)<CR>
  nmap <Plug>(ide-browse-cmd-history) <Cmd>History:<CR>
  nmap <Plug>(ide-browse-history) <Cmd>call fzf#vim#history()<CR>
  nmap <Plug>(ide-browse-windows) <Cmd>call fzf#vim#windows()<CR>
else
  nmap <Plug>(ide-browse-files) :<C-U>Files<CR>
  nmap <Plug>(ide-browse-gfiles) :<C-U>GFiles<CR>
  nmap <Plug>(ide-browse-buffers) :<C-U>call fzf#vim#buffers({}, 0)<CR>
  nmap <Plug>(ide-browse-cmd-history) :<C-U>History:<CR>
  nmap <Plug>(ide-browse-history) :<C-U>call fzf#vim#history()<CR>
  nmap <Plug>(ide-browse-windows) :<C-U>call fzf#vim#windows()<CR>
endif
