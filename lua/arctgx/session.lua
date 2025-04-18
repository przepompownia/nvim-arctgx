local extension = {}

--- @todo hook names
local hooks = {
  save = {
    ---@type table<{name: string, callback: function}>
    before = {},
  },
}

local function appendHook(name, hook, event, when)
  if type(hook) ~= 'function' then
    vim.notify(
      ('Cannot add hook (%s.%s). It must be a function.'):format(event, when),
      vim.log.levels.ERROR
    )
    return
  end

  hooks[event][when][#hooks[event][when] + 1] = {name = name, callback = hook}
end

local function runHooks(event, when)
  for _, hook in ipairs(hooks[event][when]) do
    vim.notify(('Running "%s %s" hook "%s".'):format(when, event, hook.name), vim.log.levels.DEBUG)
    if false == hook.callback() then
      vim.notify(('Cannot run "%s %s" hook "%s".'):format(when, event, hook.name), vim.log.levels.WARN)

      return false
    end
  end
end

--- @param hook function
function extension.appendBeforeSaveHook(name, hook)
  appendHook(name, hook, 'save', 'before')
end

function extension.runBeforeSaveHooks()
  return runHooks('save', 'before')
end

return extension
