function! fern#mapping#arctgx#init(disable_default_mappings) abort
  nmap <silent><buffer> <Plug>(fern-action-arctgx:tabdrop) :<C-u>call <SID>tabDrop(v:false)<CR>
  nmap <silent><buffer> <Plug>(fern-action-arctgx:tabdrop-close) :<C-u>call <SID>tabDrop(v:true)<CR>
  nmap <silent><buffer> <Plug>(fern-action-arctgx:git-top) :<C-u>call <SID>gitTop(v:false)<CR>
  nmap <silent><buffer> <Plug>(fern-action-arctgx:git-top-reveal) :<C-u>call <SID>gitTop(v:true)<CR>
endfunction

function! s:tabDrop(closeAfter) abort
  let l:helper = fern#helper#new()
  let l:node = l:helper.sync.get_cursor_node()

  let l:bufnr = bufnr()

  wincmd w
  call arctgx#base#tabDrop(l:node._path)

  if v:true isnot a:closeAfter
    return
  endif

  execute 'bunload ' . l:bufnr
endfunction

function! s:gitTop(reveal) abort
  let l:helper = fern#helper#new()
  let l:cursorPath = helper.sync.get_cursor_node()._path
  let l:startDirectory = fnamemodify(l:cursorPath, ':p:h')

  try
    let l:toplevelDirectory = arctgx#git#getToplevelDirectory(l:startDirectory)
    call FernOpen(l:cursorPath, l:toplevelDirectory, a:reveal, v:false)
  catch /^Git toplevel not found for .*/
    echomsg v:exception
  endtry
endfunction
