function! fern#mapping#arctgx#init(disable_default_mappings) abort
  nmap <silent><buffer> <Plug>(fern-action-arctgx:tabdrop) :<C-u>call <SID>tabDrop()<CR>
endfunction

function! s:tabDrop() abort
  let l:helper = fern#helper#new()
  let l:node = l:helper.sync.get_cursor_node()

  execute 'tab drop ' . l:node._path
endfunction
