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

-- vim.go.termguicolors = true

api.nvim_create_autocmd('VimEnter', {
  once = true,
  pattern = '*',
  nested = true,
  callback = function ()
    vim.opt.background = 'dark'
  end,
})

-- local opts = {}
--
-- local function isTermReady()
--   return opts.background ~= nil and opts.termguicolors ~= nil
-- end
--
-- vim.api.nvim_create_autocmd('OptionSet', {
--   pattern = 'background,termguicolors',
--   callback = function (data)
--     -- vim.notify(('Setting %s to %s'):format(data.match, vim.v.option_new))
--     opts[data.match] = vim.v.option_new
--     if isTermReady() then
--       vim.schedule(function ()
--         setColorscheme(vim.go.background, vim.go.termguicolors)
--       end)
--     end
--     return true
--   end,
-- })

api.nvim_create_autocmd('OptionSet', {
  group = augroup,
  pattern = 'background',
  nested = true,
  callback = function ()
    -- if not isTermReady() then return end
    setColorscheme(vim.v.option_new, vim.go.termguicolors)
  end
})
