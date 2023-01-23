function! arctgx#arctgx#getInitialVimDirectory() abort
  return get(g:, 'initialVimDirectory', expand('~/.vim'))
endfunction

" vint: next-line -ProhibitUnusedVariable
let s:arctgxBundleDir = simplify(fnamemodify(expand('<sfile>:p:h:h:h'), ':p'))

function! s:listIdeSources() abort
  let l:ideSources = [
        \ {'source': 'plugin/ide-maps.lua', 'action': 'edit'},
        \ {'source': 'lua/arctgx/lsp.lua', 'action': 'vsplit'},
        \ {'source': 'bundleConfig/nvim-lspconfig.lua', 'action': 'split'},
        \ {'source': 'bundleConfig/nvim-cmp.lua', 'action': 'split'},
        \ {'source': 'bundleConfig/nvim-dap.lua', 'action': 'split'},
        \ ]
  return map(l:ideSources, {_, item -> {'source': s:arctgxBundleDir . item['source'], 'action': item['action']}})
endfunction

function! arctgx#arctgx#enablePrivateMode() abort
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

function! arctgx#arctgx#sudowq() abort
  if ! executable('sudo')
    echoerr 'Command sudo not found'
  endif
  exe 'w !sudo tee % > /dev/null'
  exe 'e!'
endfunction

function! arctgx#arctgx#openShell(directory) abort
  botright new

  call termopen(&shell, {'cwd': a:directory})
endfunction

function! arctgx#arctgx#editIDEMaps() abort
  tabnew
  let l:ideSources = s:listIdeSources()
  for l:item in l:ideSources
    if (!filereadable(l:item['source']))
      continue
    endif
    let l:action = l:item['action']
    execute printf('%s %s', l:action, l:item['source'])
  endfor

  wincmd w
endfunction

function! arctgx#arctgx#reloadIDEMaps() abort
  let l:ideSources = s:listIdeSources()
  for l:item in l:ideSources
    if (!filereadable(l:item['source']))
      continue
    endif
    execute 'source ' l:item['source']
  endfor

  wincmd w
endfunction

function! arctgx#arctgx#insertWithInitialIndentation(modeCharacter) abort
  if a:modeCharacter !=# 'a' && a:modeCharacter !=# 'i'
    throw 'Only "i" and "a" are allowed to enter Insert mode this way'
  endif

  call feedkeys(a:modeCharacter, 'n')

  if empty(&indentexpr)
    return
  endif

  call feedkeys("\<C-f>", 'n')
endfunction
