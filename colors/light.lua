local api = vim.api

do
  local highlights = {
    LspReferenceRead = {bg = '#E6F4AA'},
    LspReferenceText = {bg = '#F4EDAA'},
    LspReferenceWrite = {bg = '#F4DBAA'},
    DapBreakpointSign = {fg = '#1212ff'},
    DapCurrentFrameSign = {fg = '#440000'},
    DebugWidgetInactive = {
      fg = vim.api.nvim_get_hl(0, {name = 'Normal'}).fg,
    },
    DebugWidgetActive = {fg = '#bb0000'},
  }

  for name, def in pairs(highlights) do
    api.nvim_set_hl(require('arctgx.lsp').ns(), name, def)
  end
end
