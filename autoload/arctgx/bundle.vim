function! s:sourceFile(path) abort
  if !filereadable(a:path)
    throw printf('Config %s does not exist.', a:path)
    return
  endif

  execute 'source ' . a:path
endfunction

function! arctgx#bundle#listAllBundles(bundleDir) abort
  let l:all_plugins = []
  let l:plugin_paths = globpath(a:bundleDir, '*', 1, 1)

  for l:fn in l:plugin_paths
    call add(l:all_plugins, fnamemodify(l:fn, ':t'))
  endfor

  return l:all_plugins
endfunction

function! arctgx#bundle#isEnabled(bundle, bundleDir) abort
  let l:rtp = split(&runtimepath, ',')
  let l:absoluteBundlePath = expand(a:bundleDir.'/'.a:bundle)
  return index(l:rtp, l:absoluteBundlePath) >= 0 && isdirectory(l:absoluteBundlePath)
endfunction

function! arctgx#bundle#loadSingleCustomConfiguration(bundle, bundleConfigDir) abort
  let l:bundle = substitute(a:bundle, '\.\(lua\)$', '', '')
  let l:config = a:bundleConfigDir . l:bundle
  try
    call s:sourceFile(l:config . '.lua')
  catch /^Config \/.* does not exist\.$/
    " echom v:exception
  endtry
endfunction
