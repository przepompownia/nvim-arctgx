local plugin = {}

function plugin.loadCustomConfiguration(pluginDirs, pluginConfigDir)
  for _, pluginDir in ipairs(pluginDirs) do
    plugin.loadSingleConfiguration(pluginDir, pluginConfigDir)
  end
end

local function isEnabled(pluginName, pluginDir)
end

function plugin.loadSingleConfiguration(pluginDir, pluginConfigDir)
  if 0 == vim.fn.isdirectory(pluginDir) then
    return
  end

  for _, pluginName in ipairs(vim.fn['arctgx#bundle#listAllBundles'](pluginDir)) do
    if 1 == vim.fn['arctgx#bundle#isEnabled'](pluginName, pluginDir) then
      vim.fn['arctgx#bundle#loadSingleCustomConfiguration'](pluginName, pluginConfigDir)
    end
  end
end

return plugin
