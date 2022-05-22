local widgets = {}

local debugHooks = {}

function widgets.addDebugHook(hook)
  table.insert(debugHooks, hook)
end

function widgets.renderDebug()
  local out = 'D'
  for _, hook in ipairs(debugHooks) do
    out = out .. ' ' .. hook()
  end

  return out
end

return widgets
