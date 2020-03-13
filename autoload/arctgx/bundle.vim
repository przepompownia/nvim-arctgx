function arctgx#bundle#listAllBundles(bundleDir)
  let l:all_plugins = []
  let l:plugin_paths = globpath(a:bundleDir, '*', 1, 1)

  for l:fn in l:plugin_paths
    call add(l:all_plugins, fnamemodify(l:fn, ':t'))
  endfor

  return l:all_plugins
endfunction

function arctgx#bundle#isEnabled(bundle, bundleDir)
  return isdirectory(expand(a:bundleDir.'/'.a:bundle))
endfunction

function arctgx#bundle#loadCustomConfigurations(bundleDirs, bundleConfigDir)
  for dir in a:bundleDirs
    call arctgx#bundle#loadCustomConfiguration(dir, a:bundleConfigDir)
  endfor
endfunction

function arctgx#bundle#loadCustomConfiguration(bundleDir, bundleConfigDir)
  if !isdirectory(a:bundleConfigDir)
    return
  endif

  for l:bundle in arctgx#bundle#listAllBundles(a:bundleDir)
    if !arctgx#bundle#isEnabled(l:bundle, a:bundleDir)
      continue
    endif
    let l:bundle = substitute(l:bundle, '\.vim$', '', '').'.vim'
    let l:config = a:bundleConfigDir . l:bundle
    try
      call arctgx#base#sourceFile(l:config)
    catch /^Config \/.* does not exist\.$/
      continue
    catch
      echom v:exception
    endtry
  endfor
endfunction
