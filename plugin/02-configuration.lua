local plugin = require 'arctgx.plugin'
local api = vim.api
local configDir = vim.fn.expand('<sfile>:p:h')
local pluginConfigDir = vim.fn.simplify(configDir .. '/../bundleConfig/')

local augroupHighlight = api.nvim_create_augroup('ConfigureHighlight', {clear = true})
local augroupAfterVimEnter = api.nvim_create_augroup('AfterVimEnter', {clear = true})

local function configureHighlight()
  local path = vim.fn.simplify(vim.fn.fnamemodify(
      ('%s/../colors/%s.lua'):format(configDir, vim.opt.background:get()),
      ':p'
  ))
  dofile(path)
end

if vim.tbl_isempty(vim.g.pluginDirs) then
  vim.notify('Empty vim.g.pluginDirs', vim.log.levels.ERROR)
end

plugin.loadCustomConfiguration(vim.g.pluginDirs, pluginConfigDir)

api.nvim_create_autocmd('ColorScheme', {
  group = augroupHighlight,
  pattern = '*',
  callback = configureHighlight,
})

api.nvim_create_autocmd('VimEnter', {
  group = augroupAfterVimEnter,
  pattern = '*',
  nested = true,
  callback = function ()
    vim.opt.background = 'dark'
  end,
})

api.nvim_create_autocmd('VimEnter', {
  group = augroupAfterVimEnter,
  pattern = '*',
  callback = function ()
    vim.cmd.clearjumps()
  end,
})

api.nvim_create_user_command('Packadd', function (opts)
  vim.fn['arctgx#bundle#loadSingleCustomConfiguration'](opts.args, pluginConfigDir)
  vim.cmd.packadd(opts.args)
end, {nargs = 1, complete = 'packadd'})
