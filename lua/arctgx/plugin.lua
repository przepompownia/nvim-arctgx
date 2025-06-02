local plugin = {}

--- @param pluginDirs string[]
--- @param pluginPrefix string
function plugin.loadCustomConfiguration(pluginDirs, pluginPrefix)
  vim.validate('pluginDirs', pluginDirs, 'table')

  if vim.tbl_isempty(pluginDirs) then
    vim.notify('Empty vim.g.pluginDirs', vim.log.levels.ERROR)
  end

  for _, pluginPath in ipairs(vim.api.nvim_list_runtime_paths()) do
    for _, pluginDir in ipairs(pluginDirs) do
      local pluginPaths = vim.fn.globpath(pluginDir, '*', true, true)
      if vim.tbl_contains(pluginPaths, pluginPath) then
        plugin.loadSingleConfiguration(vim.fn.fnamemodify(pluginPath, ':t'), pluginPrefix)
      end
    end
  end
end

function plugin.loadSingleConfiguration(pluginName, pluginPrefix)
  local tail = pluginName:gsub('%.lua$', ''):gsub('%.', '-')
  local modulePath = vim.fs.joinpath(
    require('arctgx.base').getPluginDir(),
    'lua',
    pluginPrefix:gsub('%.', '/'),
    tail .. '.lua'
  )
  if not vim.uv.fs_stat(modulePath) then
    -- vim.notify(('For plugin %s expected path %s does not exist'):format(pluginName, modulePath), vim.log.levels.DEBUG)
    return
  end
  local pluginModule = pluginPrefix .. '.' .. tail

  require(pluginModule)
end

return plugin
