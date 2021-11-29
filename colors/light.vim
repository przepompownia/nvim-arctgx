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
highlight IdeDiagnosticWarning guibg=#fff8e8
highlight IdeDiagnosticInfo guibg=#ffffee
highlight IdeDiagnosticHint guibg=#ffffdd
highlight IdeFloating guifg=#888888 guibg=#dddddd
highlight link NormalFloat IdeFloating
highlight IdeErrorFloat guifg=#880000 guibg=#dddddd
highlight IdeWarningFloat guibg=NONE guifg=#884400
highlight IdeInfoFloat guibg=NONE guifg=#626262
highlight! link DiagnosticHint IdeDiagnosticHint
highlight! link DiagnosticInfo IdeDiagnosticInfo
highlight! link DiagnosticWarn IdeDiagnosticWarning
highlight! link DiagnosticError IdeDiagnosticError
call arctgx#highlight#highlight('IdeInfoSign', 'SignColumn', '#626262')
call arctgx#highlight#highlight('IdeWarningSign', 'SignColumn', 'WarningMsg')
call arctgx#highlight#highlight('IdeHintSign', 'SignColumn', '#15aabf')
call arctgx#highlight#highlight('IdeErrorSign', 'SignColumn', '#bb8800')
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
