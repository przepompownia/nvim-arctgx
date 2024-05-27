local plugin = require 'arctgx.plugin'
local pluginPrefix = 'arctgx.pluginConfigs'

plugin.loadCustomConfiguration(vim.g.pluginDirs or {}, pluginPrefix)

vim.api.nvim_create_autocmd('VimEnter', {
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

vim.api.nvim_create_user_command('Packadd', function (opts)
  vim.cmd.packadd(opts.args)
  plugin.loadSingleConfiguration(opts.args, pluginPrefix, require('arctgx.base').getPluginDir())
end, {nargs = 1, complete = 'packadd'})
