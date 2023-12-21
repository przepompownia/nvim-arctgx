local function configureHighlight()
  local path = vim.uv.fs_realpath(
    ('%s/colors/%s.lua'):format(require('arctgx.base').getPluginDir(), vim.opt_global.background:get())
  )
  dofile(path)
end

local function colorscheme(bg, tgc)
  if bg == 'light' then
    return tgc and vim.g.colorschemeLight or 'delek'
  end
  return tgc and vim.g.colorschemeDark or 'habamax'
end

local colorschemeReadyOptions = {'background', 'termguicolors'}

vim.api.nvim_create_autocmd('OptionSet', {
  group = vim.api.nvim_create_augroup('ColorschemeLoading', {clear = true}),
  nested = true,
  pattern = colorschemeReadyOptions,
  callback = function ()
    if vim.iter(colorschemeReadyOptions):all(function (option)
        return vim.api.nvim_get_option_info2(option, {}).was_set
      end) then
      vim.api.nvim_cmd({cmd = 'colorscheme', args = {colorscheme(vim.go.background, vim.go.termguicolors)}}, {})
    end
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('ConfigureHighlight', {clear = true}),
  pattern = '*',
  callback = configureHighlight,
})
