local extension = {}

local hooks = {
  save = {
    ---@type table<function>
    before = {},
  },
}

local function appendHook(hook, event, when)
  if type(hook) ~= 'function' then
    vim.notify(
      ('Cannot add session hook (%s.%s). It must be a function.'):format(event, when),
      vim.log.levels.ERROR
    )
    return
  end

  table.insert(hooks[event][when], hook)
end

local function runHook(event, when)
  for _, hook in ipairs(hooks[event][when]) do
    hook()
  end
end

---@param hook function
function extension.appendBeforeSaveHook(hook)
  appendHook(hook, 'save', 'before')
end

function extension.runBeforeSaveHooks()
  runHook('save', 'before')
end

return extension
