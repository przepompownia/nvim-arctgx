local plugin = {}

--- @param pluginDir string
local function listAllPlugins(pluginDir)
  local plugins = {}
  local pluginPaths = vim.fn.globpath(pluginDir, '*', 1, 1)
  for _, path in ipairs(pluginPaths) do
    plugins[#plugins + 1] = vim.fn.fnamemodify(path, ':t')
  end

  return plugins
end

--- @param pluginDirs table
--- @param pluginPrefix string
function plugin.loadCustomConfiguration(pluginDirs, pluginPrefix)
  vim.validate('pluginDirs', pluginDirs, 'table')

  if vim.tbl_isempty(pluginDirs) then
    vim.notify('Empty vim.g.pluginDirs', vim.log.levels.ERROR)
  end

  local rtp = vim.api.nvim_list_runtime_paths()

  for _, pluginDir in ipairs(pluginDirs) do
    for _, pluginName in ipairs(listAllPlugins(pluginDir)) do
      if vim.tbl_contains(rtp, vim.uv.fs_realpath(pluginDir .. '/' .. pluginName)) then
        plugin.loadSingleConfiguration(pluginName, pluginPrefix)
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

  local ok, out = pcall(require, pluginModule)
  if not ok then
    vim.notify(out, vim.log.levels.WARN, {title = 'Plugin configuration'})
  end
end

return plugin
