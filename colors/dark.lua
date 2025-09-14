local api = vim.api

do
  local highlights = {
    LspReferenceRead = {bg = '#5B532C'},
    LspReferenceText = {bg = '#2C3C5B'},
    LspReferenceWrite = {bg = '#4B281D'},
    DapBreakpointSign = {fg = '#1212ff'},
    DapCurrentFrameSign = {fg = '#440000'},
  }

  for name, def in pairs(highlights) do
    api.nvim_set_hl(require('arctgx.lsp').ns(), name, def)
  end
end
