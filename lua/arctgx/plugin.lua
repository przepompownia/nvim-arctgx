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
  for _, pluginDir in ipairs(pluginDirs) do
    for _, pluginName in ipairs(listAllPlugins(pluginDir)) do
      if vim.tbl_contains(vim.opt.runtimepath:get(), vim.loop.fs_realpath(pluginDir .. '/' .. pluginName)) then
        plugin.loadSingleConfiguration(pluginName, pluginConfigDir)
      end
    end
  end
end

function plugin.loadSingleConfiguration(pluginName, pluginConfigDir)
  local pluginFilePath = vim.loop.fs_realpath(pluginConfigDir .. '/' .. pluginName:gsub('%.lua$', '') .. '.lua')

  if nil == pluginFilePath then
    -- vim.notify(('Config %s does not exist'):format(pluginName))
    return
  end

  dofile(pluginFilePath)
end

return plugin
