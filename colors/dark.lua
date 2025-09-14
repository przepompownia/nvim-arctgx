local api = vim.api

do
  local highlights = {
    LspReferenceRead = {bg = '#5B532C'},
    LspReferenceText = {bg = '#2C3C5B'},
    LspReferenceWrite = {bg = '#4B281D'},
    IdeBreakpointSign = {fg = '#1212ff'},
    IdeCodeWindowCurrentFrameSign = {fg = '#440000'},
    IdeCodeWindowCurrentFrameLineNr = {
      link = 'IdeCodeWindowCurrentFrameSign',
    },
  }

  for name, def in pairs(highlights) do
    api.nvim_set_hl(require('arctgx.lsp').ns(), name, def)
  end
end
