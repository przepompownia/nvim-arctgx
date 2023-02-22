local plugin = {}

function plugin.loadCustomConfiguration(pluginDirs, pluginConfigDir)
  for _, pluginDir in ipairs(pluginDirs) do
    for _, pluginName in ipairs(vim.fn['arctgx#bundle#listAllBundles'](pluginDir)) do
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
