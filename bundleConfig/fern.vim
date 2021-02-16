function! s:defineMappings() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> m <Plug>(fern-action-mark:toggle)j
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> V <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> <Right> <Plug>(fern-action-expand)
  nmap <buffer> <Left> <Plug>(fern-action-collapse)
  nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)
  nmap <buffer> <nowait> q :q<CR>
endfunction

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

nnoremap <Plug>(ide-tree-focus-current-file) :Fern %:p:h -width=40 -drawer -reveal=%<CR>
