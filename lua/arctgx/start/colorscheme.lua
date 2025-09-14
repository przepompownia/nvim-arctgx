local api = vim.api

local function onlyFg(hlGroup)
  return {fg = vim.api.nvim_get_hl(0, {name = hlGroup}).fg}
end

local function configureHighlight()
  local highlights = {
    dark = {
      LspReferenceRead = {bg = '#5B532C'},
      LspReferenceText = {bg = '#2C3C5B'},
      LspReferenceWrite = {bg = '#4B281D'},
      DapBreakpointSign = {fg = '#1212ff'},
      DapCurrentFrameSign = {fg = '#440000'},
      DebugWidgetInactive = onlyFg('Normal'),
      DebugWidgetActive = {fg = '#bb0000'},
      StatuslineDiffAdd = onlyFg('DiffAdd'),
      StatuslineDiffChange = onlyFg('DiffChange'),
      StatuslineDiffDelete = onlyFg('DiffDelete'),
    },
    light = {
      LspReferenceRead = {bg = '#E6F4AA'},
      LspReferenceText = {bg = '#F4EDAA'},
      LspReferenceWrite = {bg = '#F4DBAA'},
      DapBreakpointSign = {fg = '#1212ff'},
      DapCurrentFrameSign = {fg = '#440000'},
      DebugWidgetInactive = onlyFg('Normal'),
      DebugWidgetActive = {fg = '#bb0000'},
      StatuslineDiffAdd = onlyFg('DiffAdd'),
      StatuslineDiffChange = onlyFg('DiffChange'),
      StatuslineDiffDelete = onlyFg('DiffDelete'),
    },
  }
  for name, def in pairs(highlights[vim.go.background]) do
    api.nvim_set_hl(require('arctgx.lsp').ns(), name, def)
  end
end

local function colorscheme(bg, tgc)
  if bg == 'light' then
    return tgc and vim.g.colorschemeLight or 'delek'
  end
  return tgc and vim.g.colorschemeDark or 'habamax'
end

require('arctgx.base').onColorschemeReady(
  'ColorschemeLoading',
  function ()
    api.nvim_cmd({cmd = 'colorscheme', args = {colorscheme(vim.go.background, vim.go.termguicolors)}}, {})
  end
)

api.nvim_create_autocmd('ColorScheme', {
  group = api.nvim_create_augroup('ConfigureHighlight', {clear = true}),
  pattern = '*',
  callback = configureHighlight,
})
