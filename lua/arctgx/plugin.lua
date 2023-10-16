local plugin = {}

local function listAllPlugins(pluginDir)
  local plugins = {}
  local pluginPaths = vim.fn.globpath(pluginDir, '*', 1, 1)
  for _, path in ipairs(pluginPaths) do
    table.insert(plugins, vim.fn.fnamemodify(path, ':t'))
  end

  return plugins
end

function plugin.loadCustomConfiguration(pluginDirs, pluginPrefix)
  vim.validate({
    pluginDirs = {pluginDirs, 'table'},
    pluginConfigDir = {pluginPrefix, 'string'},
  })

  if vim.tbl_isempty(pluginDirs) then
    vim.notify('Empty vim.g.pluginDirs', vim.log.levels.ERROR)
  end

  for _, pluginDir in ipairs(pluginDirs) do
    for _, pluginName in ipairs(listAllPlugins(pluginDir)) do
      if vim.tbl_contains(vim.opt.runtimepath:get(), vim.uv.fs_realpath(pluginDir .. '/' .. pluginName)) then
        plugin.loadSingleConfiguration(pluginName, pluginPrefix)
      end
    end
  end
end

function plugin.loadSingleConfiguration(pluginName, pluginPrefix)
  local tail = pluginName:gsub('%.lua$', ''):gsub('%.', '-')
  if not vim.uv.fs_stat(require('arctgx.base').getPluginDir() .. '/lua/' .. pluginPrefix:gsub('%.', '/') .. '/' .. tail .. '.lua') then
    return
  end
  local pluginModule = pluginPrefix .. '.' .. tail

  local ok, out = pcall(require, pluginModule)
  if not ok then
    vim.notify(out, vim.log.levels.WARN)
  end
end

return plugin
