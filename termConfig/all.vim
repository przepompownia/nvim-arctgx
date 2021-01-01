hi Folded term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=LightGrey guifg=DarkBlue
hi FoldColumn term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue

if has('nvim')
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
