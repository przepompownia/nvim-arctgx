function! arctgx#fold#foldText()
  let l:line = getline(v:foldstart)
  let l:regex = substitute(escape(&commentstring, ' *'), '%s', '\\(.*\\)', '')
  let l:line = substitute(l:line, l:regex, '\1', '')
  let l:regex = substitute(&foldmarker,'[0-9]+','','')
  let l:regex = substitute(l:regex,",","\\\\|",'')
  let l:sub = substitute(l:line, l:regex, '', 'g')
  return v:folddashes . l:sub
endfunction
