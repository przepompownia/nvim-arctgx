local widgets = {}

local function formatDebugWidget(hl, symbol, fallbackHl, status)
  return ('%%#%s#%s%%#%s#%s '):format(hl, symbol, fallbackHl, status)
end

--- @return {session: boolean, status: string}?
local function debugHook() end

widgets.debugHook = debugHook

local function resetHl(rHl)
  return (' %%#%s#'):format(rHl or 'Normal')
end

--- @param highlights {active: string, inactive: string, fallback: string}
--- @return string
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
  ['  '] = 'DiagnosticError',
  [' 󰀪 '] = 'DiagnosticWarn',
  ['  '] = 'DiagnosticInfo',
  ['  '] = 'DiagnosticHint',
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

-- copied from feline.nvim
function widgets.searchCount()
  if vim.v.hlsearch == 0 then
    return ''
  end

  local ok, result = pcall(vim.fn.searchcount, {maxcount = 999, timeout = 250})
  if not ok or next(result) == nil or result.incomplete == 1 then
    return ''
  end

  local denominator = math.min(result.total, result.maxcount)
  return string.format(' [%d/%d] ', result.current, denominator)
end

function widgets.renderVcsBranch()
  local head = vim.b.gitsigns_head
  if not head then
    return ''
  end

  return ' ' .. (head) .. ' '
end

function widgets.renderVcsSummary(rHl)
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

  return result .. resetHl(rHl)
end

function widgets.renderDiagnosticsSummary(rHl)
  local count = vim.diagnostic.count(0, {})
  local result =
    renderDiagnosticPart('  ', count[1])
    .. renderDiagnosticPart(' 󰀪 ', count[2])
    .. renderDiagnosticPart('  ', count[3])
    .. renderDiagnosticPart('  ', count[4])

  if '' == result then
    return ''
  end

  return result .. resetHl(rHl)
end

return widgets
