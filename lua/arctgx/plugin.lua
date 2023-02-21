local plugin = {}

function plugin.loadCustomConfiguration(pluginDirs, pluginConfigDir)
  for _, pluginDir in ipairs(pluginDirs) do
    vim.fn['arctgx#bundle#loadCustomConfiguration'](pluginDir, pluginConfigDir)
    print(pluginDir)
  end
end

return plugin
