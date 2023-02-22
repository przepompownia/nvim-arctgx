function! arctgx#bundle#listAllBundles(bundleDir) abort
  let l:all_plugins = []
  let l:plugin_paths = globpath(a:bundleDir, '*', 1, 1)

  for l:fn in l:plugin_paths
    call add(l:all_plugins, fnamemodify(l:fn, ':t'))
  endfor

  return l:all_plugins
endfunction
