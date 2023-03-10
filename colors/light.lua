do
  local api = vim.api
  local highlights = {
    IdeDiagnosticError = {bg='#fff6f6'},
    IdeDiagnosticWarning = {bg='#fff8e8'},
    IdeDiagnosticInfo = {bg='#ffffee'},
    IdeDiagnosticHint = {bg='#ffffdd'},
    IdeFloating = {bg='#dddddd', fg='#888888'},
    IdeErrorFloat = {bg='#dddddd', fg='#880000'},
    IdeWarningFloat = {fg='#884400'},
    IdeInfoFloat = {fg='#626262'},
    IdeReferenceRead = {bg='#E6F4AA'},
    IdeReferenceText = {bg='#F4EDAA'},
    IdeReferenceWrite = {bg='#F4DBAA'},
    IdeBreakpointSign = {fg='#1212ff'},
    IdeInfoSign = {fg = '#626262'},
    IdeWarningSign = {fg = api.nvim_get_hl_by_name('WarningMsg', true).background},
    IdeHintSign = {fg = '#15aabf'},
    IdeErrorSign = {fg = '#bb8800'},
    IdeBreakpointLineNr = {link = 'IdeBreakpointSign'},
    IdeCodeWindowCurrentFrameSign = {fg = '#440000'},
    IdeCodeWindowCurrentFrameLineNr = {link = 'IdeCodeWindowCurrentFrameSign'},
    IdeGutterAdd = {fg = '#008800'},
    IdeGutterChange = {fg = '#000088'},
    IdeGutterDelete = {fg = '#880000'},
    IdeGutterTopDelete = {fg = '#880000'},
    IdeGutterChangeDelete = {fg = '#884400'},
  }

  for name, def in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, def)
  end
end
