function arctgx#bundle#listAllBundles(bundleDir)
  let l:all_plugins = []
  let l:plugin_paths = globpath(a:bundleDir, '*', 1, 1)

  for l:fn in l:plugin_paths
    call add(l:all_plugins, fnamemodify(l:fn, ':t'))
  endfor

  return l:all_plugins
endfunction

function arctgx#bundle#isEnabled(bundle, bundleDir)
  let l:rtp = split(&runtimepath, ',')
  let l:absoluteBundlePath = expand(a:bundleDir.'/'.a:bundle)
  return index(l:rtp, l:absoluteBundlePath) >= 0 && isdirectory(l:absoluteBundlePath)
endfunction

function arctgx#bundle#loadCustomConfigurations(bundleDirs, bundleConfigDir)
  for l:dir in a:bundleDirs
    call arctgx#bundle#loadCustomConfiguration(l:dir, a:bundleConfigDir)
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
      " echom v:exception
      continue
    endtry
  endfor
endfunction
