function arctgx#term#loadConfiguration(configDir)
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
