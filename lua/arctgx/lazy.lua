local lazy = {}

--- @type table <string, {callback: fun()?, method: string?, args: table?}[]>
local configs = {}
--- @type table <string, boolean>
local loaded = {}

function lazy.setupAtFirstLoader(modname)
  if configs[modname] and not loaded[modname] then
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

return lazy
