function arctgx#completion#getSubsequenceRegex(string)
  let regex = join(split(escape(a:string, '.*+[]'), '\zs'), '.*')
  return regex
endfunction

function arctgx#completion#filterListByRegex(list, regex)
  return filter(a:list, 'v:val =~ "'. a:regex .'"')
endfunction

" set omnifunc=arctgx#completion#completeBundles
function arctgx#completion#completeBundles(findstart, base)
  if empty(g:bundle_dirs)
    return []
  endif
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] !~  '["'']'
      let start -= 1
    endwhile
    return start
  endif

  let suggestions = []
  let regex = arctgx#completion#getSubsequenceRegex(a:base)
  for s:dir in g:bundle_dirs
    let suggestions += arctgx#completion#filterListByRegex(arctgx#bundle#listAllBundles(s:dir), regex)
  endfor

  return suggestions
endfunction
