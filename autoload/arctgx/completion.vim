function! arctgx#completion#getSubsequenceRegex(string) abort
  let l:regex = join(split(escape(a:string, '.*+[]'), '\zs'), '.*')
  return l:regex
endfunction

function! arctgx#completion#filterListByRegex(list, regex) abort
  return filter(a:list, 'v:val =~ "'. a:regex .'"')
endfunction

" set omnifunc=arctgx#completion#completeBundles
function! arctgx#completion#completeBundles(findstart, base) abort
  if empty(g:bundle_dirs)
    return []
  endif
  if a:findstart
    let l:line = getline('.')
    let l:start = col('.') - 1
    while l:start > 0 && l:line[l:start - 1] !~? '["'']'
      let l:start -= 1
    endwhile
    return l:start
  endif

  let l:suggestions = []
  let l:regex = arctgx#completion#getSubsequenceRegex(a:base)
  for s:dir in g:bundle_dirs
    let l:suggestions += arctgx#completion#filterListByRegex(arctgx#bundle#listAllBundles(s:dir), l:regex)
  endfor

  return l:suggestions
endfunction
