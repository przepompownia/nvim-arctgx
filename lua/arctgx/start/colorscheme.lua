local api = vim.api

local function configureHighlight()
  local path = vim.uv.fs_realpath(
    ('%s/colors/%s.lua'):format(require('arctgx.base').getPluginDir(), vim.go.background)
  )
  dofile(path)
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
