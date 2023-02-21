function s:loadTermConfiguration()
  let &t_SI .= "\<Esc>[4 q"
  let &t_EI .= "\<Esc>[2 q"

  if exists('g:GuiLoaded') || has('gui_running')
    return
  endif

  if $TERM == 'linux'
    colorscheme desert
  endif
  " vim.keymap.set('i', '', '<C-BS>')

  if $TERM == 'nvim'
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    map ® <A-.>
    map  <C-/>
  endif
endfunction

let g:bundle_dirs = get(g:, 'bundle_dirs', [])
try
  if empty(g:bundle_dirs)
    throw 'Empty g:bundle_dirs'
  endif

  set termguicolors
  call s:loadTermConfiguration()
catch /^Vim\%((\a\+)\)\=:E117/
  echomsg v:exception
endtry
