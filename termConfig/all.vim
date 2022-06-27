if has('nvim')
  augroup ArctgxNvimTermCursor
    autocmd!
    autocmd ColorScheme,VimEnter,VimResume *
          \ hi Cursor guifg=red guibg=#888888 |
          \ hi Cursor2 guifg=red guibg=#000000 |
          \ set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50
  augroup END
  finish
endif

" solid underscore
let &t_SI .= "\<Esc>[4 q"
" solid block
let &t_EI .= "\<Esc>[2 q"
" 1 or 0 -> blinking block
" 3 -> blinking underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

if has('mouse')
  if &term =~ '^screen' || &term =~# '^st\(term\)\=-256color$'
    " tmux knows the extended mouse mode
    set ttymouse=sgr
  endif
endif
