local lazy = {}

--- @alias arctgx.lazy.config {before: fun(), after: fun(), dependentModules: string[]}

--- @type table <string, arctgx.lazy.config[]>
local configs = {}
--- @type table <string, boolean>
local loaded = {}

local function setupAtFirstLoader(modname)
  if not configs[modname] or loaded[modname] or nil ~= package.loaded[modname] then
    return nil
  end

  for _, config in ipairs(configs[modname]) do
    if config.before then
      config.before()
    end
  end

  loaded[modname] = true
  for _, config in ipairs(configs[modname]) do
    for _, dependentModule in ipairs(config.dependentModules or {}) do
      require(dependentModule)
    end
  end

  local module = require(modname)

  for _, config in ipairs(configs[modname]) do
    if config.after then
      config.after()
    end
  end

  return function ()
    return module
  end
end

local function addConfig(modname, config)
  configs[modname] = configs[modname] or {}
  configs[modname][#configs[modname] + 1] = config
end

--- @param modname string
--- @param after fun()
function lazy.setupOnLoad(modname, after, dependentModules)
  addConfig(modname, {after = after, dependentModules = dependentModules})
end

--- transitional to reimplement setupOnLoad
---@param modname string
---@param config arctgx.lazy.config
function lazy.setupOnLoad2(modname, config)
  addConfig(modname, config)
end

table.insert(package.loaders, 2, setupAtFirstLoader)

return lazy
