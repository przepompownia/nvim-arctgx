highlight SignColumn ctermbg=254
highlight Folded term=standout ctermbg=LightGrey ctermfg=DarkBlue guifg=#a0a0a0 guibg=#eeeeee gui=NONE
highlight FoldColumn term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=#eeeeff guifg=#888888 gui=NONE
highlight CursorLine ctermbg=255 ctermfg=239 guibg=#dadada gui=NONE
highlight CursorLineNr gui=NONE
highlight DiffAdd term=reverse cterm=NONE ctermbg=145 ctermfg=239 guibg=#efffda gui=NONE
highlight DiffDelete term=reverse ctermbg=253 ctermfg=250 guibg=#fff2ff guifg=#cccccc
highlight DiffChange term=reverse cterm=NONE ctermbg=188 ctermfg=16 guibg=#e1e1c8
highlight DiffText term=reverse cterm=NONE ctermbg=188 ctermfg=166 gui=NONE
highlight LineNr ctermbg=255 guibg=#eeeeee
highlight IdeDiagnosticError guibg=#fff6f6
highlight IdeDiagnosticWarning guibg=#fff6aa
highlight IdeDiagnosticInfo guibg=#ffffee
highlight IdeDiagnosticHint guibg=#ffffdd
highlight IdeFloating guifg=#888888 guibg=#dddddd
highlight IdeErrorFloat guifg=#880000 guibg=#dddddd
highlight IdeWarningFloat guibg=NONE guifg=#884400
highlight IdeInfoFloat guibg=NONE guifg=#626262
call arctgx#highlight#highlight('IdeInfoSign', 'SignColumn', '#626262')
call arctgx#highlight#highlight('IdeWarningSign', 'SignColumn', 'WarningMsg')
call arctgx#highlight#highlight('IdeHintSign', 'SignColumn', '#15aabf')
call arctgx#highlight#highlight('IdeErrorSign', 'SignColumn', '#ff0000')
call arctgx#highlight#highlight('IdeGutterAdd', 'SignColumn', '#008800')
call arctgx#highlight#highlight('IdeGutterChange', 'SignColumn', '#000088')
call arctgx#highlight#highlight('IdeGutterDelete', 'SignColumn', '#880000')
call arctgx#highlight#highlight('IdeGutterTopDelete', 'SignColumn', '#880000')
call arctgx#highlight#highlight('IdeGutterChangeDelete', 'SignColumn', '#884400')
