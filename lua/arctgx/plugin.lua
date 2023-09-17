local plugin = {}

local function listAllPlugins(pluginDir)
  local plugins = {}
  local pluginPaths = vim.fn.globpath(pluginDir, '*', 1, 1)
  for _, path in ipairs(pluginPaths) do
    table.insert(plugins, vim.fn.fnamemodify(path, ':t'))
  end

  return plugins
end

function plugin.loadCustomConfiguration(pluginDirs, pluginConfigDir)
  vim.validate({
    pluginDirs = {pluginDirs, 'table'},
    pluginConfigDir = {pluginConfigDir, 'string'},
  })

  if vim.tbl_isempty(pluginDirs) then
    vim.notify('Empty vim.g.pluginDirs', vim.log.levels.ERROR)
  end

  for _, pluginDir in ipairs(pluginDirs) do
    for _, pluginName in ipairs(listAllPlugins(pluginDir)) do
      if vim.tbl_contains(vim.opt.runtimepath:get(), vim.uv.fs_realpath(pluginDir .. '/' .. pluginName)) then
        plugin.loadSingleConfiguration(pluginName, pluginConfigDir)
      end
    end
  end
end

function plugin.loadSingleConfiguration(pluginName, pluginPrefix)
  local pluginFilePath = pluginPrefix .. '.' .. pluginName:gsub('%.lua$', ''):gsub('%.', '-')

  -- @todo Prevent from loading nonexisting files
  local ok, out = pcall(require, pluginFilePath)
end

return plugin
