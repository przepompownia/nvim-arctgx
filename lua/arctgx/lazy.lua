local lazy = {}

--- @type table <string, {method: string, args: table}[]>
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
      end
    end

    return function ()
      return module
    end
  end
end

setmetatable(lazy, {
  __index = function (_, modname)
    return setmetatable({}, {
      __index = function (_, method)
        return function (...)
          configs[modname] = configs[modname] or {}
          configs[modname][#configs[modname] + 1] = {method = method, args = {...}}
        end
      end
    })
  end
})

function lazy.printConfigs()
  dump(configs)
end

return lazy
