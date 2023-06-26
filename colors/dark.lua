do
  local api = vim.api
  local highlights = {
    IdeFloating = {bg = '#808080'},
    IdeDiagnosticError = {bg = '#440000'},
    IdeDiagnosticWarning = {bg = '#442200'},
    IdeDiagnosticInfo = {bg = '#345588'},
    IdeDiagnosticHint = {bg = '#884499'},
    IdeErrorFloat = {fg = '#442200'},
    IdeHintFloat = {fg = '#cc88dd'},
    IdeWarningFloat = {fg = '#ff8800'},
    IdeInfoFloat = {fg = '#afffff'},
    IdeReferenceRead = {bg = '#5B532C'},
    IdeReferenceText = {bg = '#2C3C5B'},
    IdeReferenceWrite = {bg = '#4B281D'},
    IdeBreakpointSign = {fg = '#1212ff'},
    IdeInfoSign = {fg = '#afffff'},
    IdeWarningSign = {
      fg = api.nvim_get_hl(0, {name = 'WarningMsg'}).bg,
    },
    IdeHintSign = {fg = '#884499'},
    IdeErrorSign = {fg = '#440000'},
    IdeCodeWindowCurrentFrameSign = {fg = '#440000'},
    IdeCodeWindowCurrentFrameLineNr = {
      link = 'IdeCodeWindowCurrentFrameSign',
    },
    IdeGutterAdd = {fg = '#008800'},
    IdeGutterChange = {fg = '#000088'},
    IdeGutterDelete = {fg = '#880000'},
    IdeGutterTopDelete = {fg = '#880000'},
    IdeGutterChangeDelete = {fg = '#884400'},
  }

  for name, def in pairs(highlights) do
    vim.api.nvim_set_hl(require('arctgx.lsp').ns(), name, def)
  end
end
