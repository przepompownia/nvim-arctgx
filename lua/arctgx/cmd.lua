---@class arctgx.Cmd
local Cmd = {}

---@return arctgx.Cmd
function Cmd:new(name, args)
  self.__index = self
  setmetatable(args, self)
  self.name = name

  return args
end

---@param element any
---@return integer|nil
function Cmd:indexOfOption(element)
  for k, v in ipairs(self) do
    if '--' == v and '--' ~= element then
      return
    end

    if v == element then
      return k
    end
  end
end

---@param option any
function Cmd:switchOption(option)
  if nil ~= self:removeOption(option) then
    return
  end

  self:insertOption(option)
end

---@param option any
function Cmd:removeOption(option)
  local key = self:indexOfOption(option)
  if not key then
    return
  end

  return table.remove(self, key)
end

function Cmd:indexOfOptionsEnd()
  return self:indexOfOption('--') or #self + 1
end

---@param option any
function Cmd:insertOption(option)
  table.insert(self, self:indexOfOptionsEnd(), option)
end

function Cmd:setShortOptionWithValue(option, value)
  if nil == value then
    return
  end

  self:unsetShortOptionWithValue(option)

  local optionsEnd = self:indexOfOptionsEnd()
  table.insert(self, optionsEnd, option)
  table.insert(self, optionsEnd + 1, value)
end

function Cmd:unsetShortOptionWithValue(option)
  local key = self:indexOfOption(option)
  if not key then
    return
  end

  table.remove(self, key)
  return table.remove(self, key)
end

function Cmd:appendArgument(value)
  table.insert(self, value)
end

---@return arctgx.Cmd
function Cmd:clone()
  return vim.deepcopy(self)
end

return Cmd
