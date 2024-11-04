local api = vim.api
local widgets = {}
local ns = require('arctgx.lsp').ns()

api.nvim_set_hl(ns, 'DebugWidgetInactive', {bg = '#4C566A', fg = '#E5E9F0'})
api.nvim_set_hl(ns, 'DebugWidgetActive', {bg = '#4C566A', fg = '#bb0000'})

local function formatDebugWidget(hl, symbol, fallbackHl, status)
  return ('%%#%s#%s%%#%s#%s'):format(hl, symbol, fallbackHl, status)
end

--- @return {session: boolean, status: string}?
local function debugHook() end

widgets.debugHook = debugHook

--- @param highlights {active: string, inactive: string, fallback: string}
function widgets.renderDebug(highlights)
  local data = widgets.debugHook()
  if not data then return '' end

  return formatDebugWidget(
    data.session and highlights.active or highlights.inactive,
    data.session and '⛧ ' or '☠ ',
    highlights.fallback,
    data.session and ' ' .. data.status or ''
  )
end

return widgets
