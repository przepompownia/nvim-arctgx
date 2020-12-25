if !has('nvim')
  set <A-.>=.
  set <S-Up>=[1;2A
  set <S-Down>=[1;5B
  set <S-F3>=[1;2R
  set <S-F2>=[1;2Q
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

highlight LineNr ctermbg=255
highlight SignColumn ctermbg=254
highlight Folded term=standout cterm=NONE ctermbg=255 ctermfg=248
highlight FoldColumn term=standout ctermbg=255 ctermfg=253

highlight DiffAdd term=reverse cterm=NONE ctermbg=145 ctermfg=239
highlight DiffChange term=reverse cterm=NONE ctermbg=188 ctermfg=16
highlight DiffText term=reverse cterm=NONE ctermbg=188 ctermfg=166
highlight DiffDelete term=reverse ctermbg=253 ctermfg=250
highlight CursorLine ctermbg=255 ctermfg=239
