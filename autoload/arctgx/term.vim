function s:loadSingleConfig(configDir, config)
  let l:config = expand(a:configDir .'/'. a:config.'.vim')
  try
    call arctgx#base#sourceFile(l:config)
  catch
    echom v:exception
  endtry
endfunction

function arctgx#term#loadConfiguration(configDir)
  call s:loadSingleConfig(a:configDir, 'all')
  if $TERM == 'linux'
    colorscheme desert
  endif
  if $TERM =~ '^xterm'
    call s:loadSingleConfig(a:configDir, 'xterm')
  endif

  if $TERM =~ '-256color'
    call s:loadSingleConfig(a:configDir, '256color')
  endif
  if !empty($TMUX)
    call s:loadSingleConfig(a:configDir, 'tmux')
  endif

  if $TERM == 'nvim'
    " map <F15> <S-F3> " ultisnips dawał błąd w trybie wstawiania na
    " zmienionym pliku
    map ® <A-.>
    map  <C-/>
  endif

  if $TERM =~ 'rxvt-unicode$'
    call s:loadSingleConfig(a:configDir, 'rxvt-unicode')
  endif

  if &termguicolors == 1
    call s:loadSingleConfig(a:configDir, 'termguicolors')
  endif
endfunction
