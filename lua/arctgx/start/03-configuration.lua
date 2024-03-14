local plugin = require 'arctgx.plugin'
local api = vim.api
local pluginPrefix = 'arctgx.pluginConfigs'

-- remove it after nvim 0.10 will be available
if nil == vim.uv then
  vim.uv = vim.loop
end

plugin.loadCustomConfiguration(vim.g.pluginDirs or {}, pluginPrefix)

api.nvim_create_autocmd('VimEnter', {
  once = true,
  pattern = '*',
  callback = function ()
    vim.cmd.clearjumps()
  end,
})

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function ()
    if 1 == vim.fn.has('gui_running') then
      require 'arctgx.ginit'
    end
  end
})

api.nvim_create_user_command('Packadd', function (opts)
  vim.cmd.packadd(opts.args)
  plugin.loadSingleConfiguration(opts.args, pluginPrefix, require('arctgx.base').getPluginDir())
end, {nargs = 1, complete = 'packadd'})
