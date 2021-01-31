command! -nargs=* -complete=file CH execute 'CHADopen ' . expand(<q-args>)

nnoremap <Plug>(ide-tree-focus-current-file) <Cmd>execute 'CHADopen ' . fnameescape(bufname())<CR>

let g:chadtree_settings = {
      \ 'theme.icon_glyph_set': 'ascii',
      \ 'keymap.secondary': ['<right>', '<left>', '<2-leftmouse>'],
      \ }

augroup CHADSettings
  autocmd!

  autocmd FileType CHADTree let b:ideTabName = 'CHADTree'
augroup end
