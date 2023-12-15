local api = vim.api
local augroup = api.nvim_create_augroup('ColorschemeLoading', {clear = true})
local augroupHighlight = api.nvim_create_augroup('ConfigureHighlight', {clear = true})

local function configureHighlight()
  local path = vim.fn.simplify(vim.fn.fnamemodify(
    ('%s/colors/%s.lua'):format(require('arctgx.base').getPluginDir(), vim.opt_global.background:get()),
    ':p'
  ))
  dofile(path)
end

api.nvim_create_autocmd('ColorScheme', {
  group = augroupHighlight,
  pattern = '*',
  callback = configureHighlight,
})

local function colorscheme(bg, tgc)
  if bg == 'light' then
    return tgc and vim.g.colorschemeLight or 'delek'
  end
  return tgc and vim.g.colorschemeDark or 'habamax'
end

local function setColorscheme(bg, tgc)
  api.nvim_cmd({cmd = 'colorscheme', args = {colorscheme(bg, tgc)}}, {})
end

api.nvim_create_autocmd('UIEnter', {
  nested = true,
  callback = vim.schedule_wrap(function ()
    setColorscheme(vim.go.background, vim.go.termguicolors)
  end),
})

api.nvim_create_autocmd('OptionSet', {
  group = augroup,
  pattern = 'background',
  nested = true,
  callback = function ()
    setColorscheme(vim.v.option_new, vim.go.termguicolors)
  end
})
