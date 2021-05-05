highlight IdeFloating guibg=#808080 guifg=bg
highlight IdeDiagnosticError guibg=#440000
highlight IdeDiagnosticWarning guibg=#442200
highlight IdeDiagnosticInfo guibg=#345588
highlight IdeDiagnosticHint guibg=#884499
highlight IdeErrorFloat guibg=NONE guifg=#442200
highlight IdeHintFloat guibg=NONE guifg=#cc88dd
highlight IdeWarningFloat guibg=NONE guifg=#ff8800
highlight IdeInfoFloat guibg=NONE guifg=#afffff
call arctgx#highlight#highlight('IdeWarningSign', 'SignColumn', 'WarningMsg')
call arctgx#highlight#highlight('IdeInfoSign', 'SignColumn', '#afffff')
call arctgx#highlight#highlight('IdeErrorSign', 'SignColumn', '#440000')
call arctgx#highlight#highlight('IdeHintSign', 'SignColumn', '#884499')
call arctgx#highlight#highlight('IdeBreakpointSign', 'SignColumn', '#1212ff')
call arctgx#highlight#highlight('IdeBreakpointLineNr', 'LineNr', 'IdeBreakpointSign')
call arctgx#highlight#highlight('IdeCodeWindowCurrentFrameSign', 'SignColumn', '#440000')
call arctgx#highlight#highlight('IdeCodeWindowCurrentFrameLineNr', 'LineNr', 'IdeCodeWindowCurrentFrameSign')
call arctgx#highlight#highlight('IdeGutterAdd', 'SignColumn', '#008800')
call arctgx#highlight#highlight('IdeGutterChange', 'SignColumn', '#000088')
call arctgx#highlight#highlight('IdeGutterDelete', 'SignColumn', '#880000')
call arctgx#highlight#highlight('IdeGutterTopDelete', 'SignColumn', '#880000')
call arctgx#highlight#highlight('IdeGutterChangeDelete', 'SignColumn', '#884400')
call arctgx#highlight#highlight('IdeLineNrHint', 'LineNr', 'IdeHintSign')
call arctgx#highlight#highlight('IdeLineNrInfo', 'LineNr', 'IdeInfoSign')
call arctgx#highlight#highlight('IdeLineNrWarning', 'LineNr', 'IdeWarningSign')
call arctgx#highlight#highlight('IdeLineNrError', 'LineNr', 'IdeErrorSign')
