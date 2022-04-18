local cmd = require 'arctgx.cmd'

---@class arctgx.git.diff : arctgx.Cmd
local extension = {}

---@return arctgx.git.diff
function extension:new(name, list)
  local command = cmd:new(name, list)
  for key, value in pairs(getmetatable(command)) do
  -- for key, value in pairs(cmd) do
    if '__index' ~= key and 'new' ~= key then
      self[key] = self[key] or value
    end
  end
  self.__index = self
  setmetatable(list, self)
  self.name = name

  return list
end

function extension:switchNamesOnly()
  self:switchOption('--name-only')
end

function extension:setQuery(queryType, query)
  local allowedTypes = {'-S', '-G'}
  local typeIsValid = nil
  for _, type in ipairs(allowedTypes) do
    self:unsetShortOptionWithValue(type)
    typeIsValid = typeIsValid or type == queryType or nil
  end

  if nil == typeIsValid then
    error('Invalid query type: ' .. queryType)
  end

  self:setShortOptionWithValue(queryType, query)
end

---@param name string
---@param args table
---@param cwd string
---@return arctgx.git.diff
function extension:newCommand(name, args, cwd)
  table.insert(args, 1, 'diff')
  if nil ~= cwd then
    table.insert(args, 1, cwd)
    table.insert(args, 1, '-C')
  end
  table.insert(args, 1, 'git')

  return self:new(name, args)
end

return extension
