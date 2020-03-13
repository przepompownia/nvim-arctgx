let g:fzf_history_dir = expand('~/.cache/fzf-history')

nmap <Plug>(ide-browse-files) <Cmd>:Files<CR>
nmap <Plug>(ide-browse-gfiles) <Cmd>:GFiles<CR>

if has('nvim')
  nmap <Plug>(ide-browse-buffers) <Cmd>call fzf#vim#buffers({}, 0)<CR>
  nmap <Plug>(ide-browse-cmd-history) <Cmd>History:<CR>
  nmap <Plug>(ide-browse-history) <Cmd>call fzf#vim#history()<CR>
  nmap <Plug>(ide-browse-windows) <Cmd>call fzf#vim#windows()<CR>
else
  nmap <Plug>(ide-browse-buffers) :<C-U>call fzf#vim#buffers({}, 0)<CR>
  nmap <Plug>(ide-browse-cmd-history) :<C-U>History:<CR>
  nmap <Plug>(ide-browse-history) :<C-U>call fzf#vim#history()<CR>
  nmap <Plug>(ide-browse-windows) :<C-U>call fzf#vim#windows()<CR>
endif
