local widgets = {}

local debugHooks = {}

function widgets.addDebugHook(hook)
  table.insert(debugHooks, hook)
end

function widgets.getDebugHooks()
  return debugHooks
end

return widgets
