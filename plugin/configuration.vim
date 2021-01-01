let s:path = expand('<sfile>:p:h')
let s:bundleConfigDir = s:path . '/../bundleConfig/'
let g:bundle_dirs = get(g:, 'bundle_dirs', [])
try
  if empty(g:bundle_dirs)
    throw 'Empty g:bundle_dirs'
  endif
  call arctgx#bundle#loadCustomConfigurations(g:bundle_dirs, s:bundleConfigDir)
  set termguicolors
  call arctgx#term#loadConfiguration(s:path . '/../termConfig')
  call arctgx#base#sourceFile(s:path . '/../colors/light.vim')
catch /^Vim\%((\a\+)\)\=:E117/
  echomsg v:exception
endtry
