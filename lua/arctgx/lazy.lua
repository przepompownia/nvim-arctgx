local lazy = {}

--- @type table <string, table>
local configs = {}
--- @type table <string, boolean>
local loaded = {}

function lazy.setupAtFirstLoad(modname)
  if configs[modname] and not loaded[modname] then
    loaded[modname] = true
    local module = require(modname)
    if type(module) == 'table' and type(rawget(module, 'setup')) == 'function' then
      module.setup(configs[modname])
      return function ()
        return module
      end
    end
  end
end

setmetatable(lazy, {
  __index = function (_, modname)
    return {setup = function (config)
      configs[modname] = config
    end}
  end
})

return lazy
