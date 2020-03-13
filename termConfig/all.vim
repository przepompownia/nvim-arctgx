map j <A-j>
map k <A-k>
hi Folded term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=LightGrey guifg=DarkBlue
hi FoldColumn term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue

if !has('nvim') && has('mouse')
  if &term =~ '^screen' || &term =~# '^st\(term\)\=-256color$'
    " tmux knows the extended mouse mode
    set ttymouse=sgr
  endif
endif
