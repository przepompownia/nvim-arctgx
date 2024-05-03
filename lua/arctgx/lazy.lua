local lazy = {}

--- @type table <string, {callback: fun()}[]>
local configs = {}
--- @type table <string, boolean>
local loaded = {}

local function setupAtFirstLoader(modname)
  if not configs[modname] or loaded[modname] then
    return nil
  end

  loaded[modname] = true
  local module = require(modname)

  for _, config in ipairs(configs[modname]) do
    if config.callback then
      config.callback()
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
--- @param callback fun()
function lazy.setupOnLoad(modname, callback)
  addConfig(modname, {callback = callback})
end

table.insert(package.loaders, 2, setupAtFirstLoader)

return lazy
