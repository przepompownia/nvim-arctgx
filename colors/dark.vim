highlight IdeDiagnosticError guibg=#ffeeee
highlight IdeDiagnosticWarning guibg=#442200
highlight IdeDiagnosticInfo guibg=#345588
highlight IdeDiagnosticHint guibg=#ffffdd
highlight IdeErrorSign guifg=#ff0000 guibg=#dddddd
call arctgx#highlight#highlight('IdeInfoSign', 'SignColumn', '#afffff')
highlight IdeFloating guibg=#808080 guifg=bg
highlight IdeErrorFloat guibg=NONE guifg=#442200
highlight IdeHintFloat guibg=NONE guifg=#cc88dd
highlight IdeWarningFloat guibg=NONE guifg=#ff8800
call arctgx#highlight#highlight('IdeWarningSign', 'SignColumn', 'WarningMsg')
