local lazy = {}

--- @type table <string, {callback: fun()?, method: string?, args: table?}[]>
local configs = {}
--- @type table <string, boolean>
local loaded = {}

function lazy.setupAtFirstLoad(modname)
  if configs[modname] and not loaded[modname] then
    loaded[modname] = true
    local module = require(modname)

    for _, config in ipairs(configs[modname]) do
      if type(module) == 'table' and type(module[config.method]) == 'function' then
        module[config.method](unpack(config.args))
      elseif config.callback then
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

function lazy.before(modname, callback)
  addConfig(modname, {callback = callback})
end

setmetatable(lazy, {
  __index = function (_, modname)
    return setmetatable({}, {
      __index = function (_, method)
        return function (...)
          addConfig(modname, {method = method, args = {...}})
        end
      end
    })
  end
})

function lazy.printConfigs()
  dump(configs)
end

return lazy
