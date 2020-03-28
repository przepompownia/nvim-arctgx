function arctgx#arctgx#getInitialVimDirectory() abort
  return get(g:, 'initialVimDirectory', expand('~/.vim'))
endfunction

function arctgx#arctgx#enablePrivateMode()
  set history=0
  set nobackup
  " set nomodeline
  set noshelltemp
  set noswapfile
  set noundofile
  set nowritebackup
  set secure
  set viminfo=""
  set shada=""
endfunction

function arctgx#arctgx#sudowq()
  if ! executable('sudo')
    echoerr 'Command sudo not found'
  endif
  exe 'w !sudo tee % > /dev/null'
  exe 'e!'
endfunction

function arctgx#arctgx#openShell(directory)
  botright new
  if !has('nvim')
    call term_start(&shell, {'cwd': a:directory, 'term_finish': 'close', 'curwin': 1})
    return
  endif

  call termopen(&shell, {'cwd': a:directory})
endfunction

function arctgx#arctgx#editIDEMaps()
  execute 'lcd ' . arctgx#arctgx#getInitialVimDirectory() . '/pack/bundle/opt/arctgx/'
  tabedit plugin/ide-map.vim
  vsplit bundleConfig/coc.nvim.vim
  split bundleConfig/phpactor.vim
  split bundleConfig/fzf.vim
endfunction

function arctgx#arctgx#reloadIDEMaps()
  execute 'lcd ' . arctgx#arctgx#getInitialVimDirectory() . '/pack/bundle/opt/arctgx/'
  source plugin/ide-map.vim
  source bundleConfig/coc.nvim.vim
  source bundleConfig/phpactor.vim
  source bundleConfig/fzf.vim
endfunction

function arctgx#arctgx#insertWithInitialIndentation(modeCharacter)
  if a:modeCharacter !=# 'a' && a:modeCharacter !=# 'i'
    throw 'Only "i" and "a" are allowed to enter Insert mode this way'
  endif

  call feedkeys(a:modeCharacter, 'n')

  if empty(&indentexpr)
    return
  endif

  call feedkeys("\<C-f>", 'n')
endfunction
