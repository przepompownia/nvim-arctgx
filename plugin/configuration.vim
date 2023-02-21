function s:loadTermConfiguration(configDir)
  let &t_SI .= "\<Esc>[4 q"
  let &t_EI .= "\<Esc>[2 q"

  if exists('g:GuiLoaded') || has('gui_running')
    return
  endif

  if $TERM == 'linux'
    colorscheme desert
  endif

  if $TERM == 'nvim'
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    map ® <A-.>
    map  <C-/>
  endif
endfunction

let s:path = expand('<sfile>:p:h')
let s:bundleConfigDir = simplify(s:path . '/../bundleConfig/')
let g:bundle_dirs = get(g:, 'bundle_dirs', [])
try
  if empty(g:bundle_dirs)
    throw 'Empty g:bundle_dirs'
  endif
  call arctgx#bundle#loadCustomConfigurations(g:bundle_dirs, s:bundleConfigDir)
  set termguicolors
  call s:loadTermConfiguration(s:path . '/../termConfig')
catch /^Vim\%((\a\+)\)\=:E117/
  echomsg v:exception
endtry
