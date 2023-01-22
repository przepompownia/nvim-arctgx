---@class arctgx.History
local History = {}

function History:new(list)
  setmetatable(list, self)
  self.__index = self

  return list
end

function History:indexOf(id)
  for k, v in ipairs(self) do
    if v == id then
      return k
    end
  end
end

function History:remove(id)
  local key = self:indexOf(id)
  if nil == key then
    return
  end

  table.remove(self, key)
end

function History:putOnTop(id)
  self:remove(id)
  table.insert(self, 1, id)
end

function History:top()
  return self[1]
end

function History:previous()
  return self[2]
end

return History
