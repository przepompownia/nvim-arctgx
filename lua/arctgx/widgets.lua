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

local stlSymbolHlMap = {
  [' +'] = 'DiffAdd',
  [' ~'] = 'DiffChange',
  [' -'] = 'DiffDelete',
  ['  '] = 'StlDiagnosticError',
  [' 󰀪 '] = 'StlDiagnosticWarn',
  ['  '] = 'StlDiagnosticInfo',
  ['  '] = 'StlDiagnosticHint',
}

local symbolsStl = {}

for symbol, hlName in pairs(stlSymbolHlMap) do
  symbolsStl[symbol] = ('%%#%s#%s'):format(hlName, symbol)
end

local function renderDiagnosticPart(symbol, value)
  if not value then
    return ''
  end

  return symbolsStl[symbol] .. value
end

function widgets.renderVcsSummary(resetHl)
  local status = vim.b.gitsigns_status_dict
  if nil == status then
    return ''
  end

  local result =
    renderDiagnosticPart(' +', status.added)
    .. renderDiagnosticPart(' ~', status.changed)
    .. renderDiagnosticPart(' -', status.removed)

  if '' == result then
    return ''
  end

  return result .. ('%%#%s#'):format(resetHl or 'Normal')
end

function widgets.renderDiagnosticsSummary(resetHl)
  local count = vim.diagnostic.count(0, {})
  local result =
    renderDiagnosticPart('  ', count[1])
    .. renderDiagnosticPart(' 󰀪 ', count[2])
    .. renderDiagnosticPart('  ', count[3])
    .. renderDiagnosticPart('  ', count[4])

  if '' == result then
    return ''
  end

  return result .. ('%%#%s#'):format(resetHl or 'Normal')
end

return widgets
