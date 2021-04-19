function! s:defineMappings() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-arctgx:tabdrop-close)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nnoremap <Plug>(fern-action-close-drawer) <Cmd>FernDo close -drawer -stay<CR>
  nmap <buffer> <Plug>(fern-action-open-close)
        \ <Plug>(fern-action-open)
        \ <Plug>(fern-action-close-drawer)
  nmap <buffer> <Plug>(fern-action-split-close)
        \ <Plug>(fern-action-open:split)
        \ <Plug>(fern-action-close-drawer)
  nmap <buffer> <Plug>(fern-action-vsplit-close)
        \ <Plug>(fern-action-open:vsplit)
        \ <Plug>(fern-action-close-drawer)
  nmap <buffer> <Plug>(fern-action-select-close)
        \ <Plug>(fern-action-open:select)
        \ <Plug>(fern-action-close-drawer)
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> m <Plug>(fern-action-mark:toggle)j
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> V <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> e <Plug>(fern-action-open-close)
  nmap <buffer> <Leader>e <Plug>(fern-action-select-close)
  nmap <buffer> s <Plug>(fern-action-split-close)
  nmap <buffer> v <Plug>(fern-action-vsplit-close)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> <Right> <Plug>(fern-action-expand)
  nmap <buffer> <Left> <Plug>(fern-action-collapse)
  nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)
  nmap <buffer> <nowait> q :q<CR>
  nmap <buffer> <nowait> <Leader>r <Plug>(fern-action-arctgx:git-top-reveal)
  nmap <buffer> <A-Up> <Plug>(fern-action-focus:parent)
endfunction
call add(g:fern#mapping#mappings, 'arctgx')

augroup FernSettings
  autocmd!
  autocmd FileType fern autocmd BufEnter,WinEnter <buffer> stopinsert
  autocmd FileType fern call s:defineMappings() |
        \ let b:ideTabName = 'Fern'
augroup END

let g:fern#mark_symbol                       = '⬦'
let g:fern#renderer#default#collapsed_symbol = '▶ '
let g:fern#renderer#default#expanded_symbol  = '▼ '
let g:fern#renderer#default#leading          = ' '
let g:fern#renderer#default#leaf_symbol      = '● '
let g:fern#renderer#default#root_symbol      = '~ '

nnoremap <Plug>(ide-tree-focus-current-file) :<C-u>call FernRevealInGitToplevelIfPossible()<CR>

function! FernOpen(file, root, reveal, drawer) abort
  execute printf(
        \ 'Fern %s%s%s',
        \ fnameescape(a:root),
        \ a:reveal ? ' -reveal=' . fnameescape(a:file) : '',
        \ a:drawer ? ' -drawer -width=40' : '',
        \ )
endfunction

function! FernRevealInGitToplevelIfPossible() abort
  let l:startDirectory = arctgx#base#getBufferDirectory()

  try
    let l:toplevelDirectory = arctgx#git#getToplevelDirectory(l:startDirectory)
  catch /^Git toplevel not found for .*/
    let l:toplevelDirectory = expand('%:p:h')
  endtry

  call FernOpen(expand('%:p'), l:toplevelDirectory, v:true, v:true)
endfunction
