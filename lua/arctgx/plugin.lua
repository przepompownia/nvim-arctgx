-- packadded as late as possible
-- but need its own config to defines how to do it
local lazyPackadded = vim.g.lazyPackaddedExtensions or {}

local function loadSingleConfiguration(pluginName, pluginPrefix)
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

local function lazyPackadd(pluginName)
  lazyPackadded[#lazyPackadded + 1] = pluginName
end

--- @param pluginDirs string[]
--- @param pluginPrefix string
local function loadCustomConfiguration(pluginDirs, pluginPrefix)
  vim.validate('pluginDirs', pluginDirs, 'table')

  if vim.tbl_isempty(pluginDirs) then
    vim.notify('Empty vim.g.pluginDirs', vim.log.levels.ERROR)
  end

  local pluginPaths = {}

  for _, pluginDir in ipairs(pluginDirs) do
    for _, pluginPath in ipairs(vim.fn.globpath(pluginDir, '*', true, true)) do
      pluginPaths[pluginPath] = true
    end
  end

  for _, pluginPath in ipairs(vim.api.nvim_list_runtime_paths()) do
    if nil ~= pluginPaths[pluginPath] then
      loadSingleConfiguration(vim.fn.fnamemodify(pluginPath, ':t'), pluginPrefix)
    end
  end

  for _, pluginName in ipairs(lazyPackadded) do
    loadSingleConfiguration(pluginName, pluginPrefix)
  end
end

local plugin = {
  loadCustomConfiguration = loadCustomConfiguration,
  loadSingleConfiguration = loadSingleConfiguration,
  lazyPackadd = lazyPackadd,
}

return plugin
