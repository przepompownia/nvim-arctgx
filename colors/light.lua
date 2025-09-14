local api = vim.api

do
  local highlights = {
    LspReferenceRead = {bg = '#E6F4AA'},
    LspReferenceText = {bg = '#F4EDAA'},
    LspReferenceWrite = {bg = '#F4DBAA'},
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
