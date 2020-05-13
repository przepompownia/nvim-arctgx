function arctgx#arctgx#getInitialVimDirectory() abort
  return get(g:, 'initialVimDirectory', expand('~/.vim'))
endfunction

let s:arctgxBundleDir = simplify(fnamemodify(expand('<sfile>:p:h:h:h'), ':p'))
echomsg s:arctgxBundleDir

function s:listIdeSources() abort
  let l:ideSources = [
        \ {'source': 'plugin/ide-map.vim', 'action': 'edit'},
        \ {'source': 'bundleConfig/coc.nvim.vim', 'action': 'vsplit'},
        \ {'source': 'bundleConfig/phpactor.vim', 'action': 'split'},
        \ {'source': 'bundleConfig/fzf.vim', 'action': 'split'},
        \ {'source': 'bundleConfig/vdebug.vim', 'action': 'split'},
        \ {'source': 'bundleConfig/vim-project.vim', 'action': 'split'},
        \ ]
  return map(l:ideSources, {_, item -> {'source': s:arctgxBundleDir . item['source'], 'action': item['action']}})
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
  tabnew
  let l:ideSources = s:listIdeSources()
  for l:item in l:ideSources
    let l:action = l:item['action']
    execute printf('%s %s', l:action, l:item['source'])
  endfor
endfunction

function arctgx#arctgx#reloadIDEMaps()
  let l:ideSources = s:listIdeSources()
  for l:item in l:ideSources
    execute 'source ' l:item['source']
  endfor
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
