function! arctgx#url#open(url) abort
  call jobstart(['gio', 'open', a:url], {'detach': v:true})
endfunction

function! arctgx#url#openWithOperator(type) abort
  let l:query = arctgx#operator#getText(a:type)
  call arctgx#url#open(l:query)
endfunction
