--- @class Grep
local extension = {}

function extension:new(name, list)
  setmetatable(list, self)
  self.__index = self
  self.name = name

  return list
end

function extension:indexOf(element)
  for k, v in ipairs(self) do
    if v == element then
      return k
    end
  end
end

function extension:switch(option)
  local key = self:indexOf(option)
  if key then
    table.remove(self, key)
    return
  end

  self[#self + 1] = option
end

function extension:switchWithRequiredValue(option, value)
  local key = self:indexOf(option)
  if key then
    table.remove(self, key)
    table.remove(self, key)
    return
  end

  self[#self + 1] = option
  self[#self + 1] = value
end

--- @return string
function extension:status()
  local settings = {
    self:indexOf('--fixed-strings') and 'Fixed strings' or 'Regex',
    'Case ' .. (self:indexOf('--ignore-case') and 'insensitive' or 'sensitive'),
    (self:indexOf('--max-count') and 'Only first result' or nil),
  }

  return ('%s: %s'):format(self.name, table.concat(settings, ', '))
end

function extension:switchFixedStrings()
  self:switch('--fixed-strings')
end

function extension:switchCaseSensibility()
  self:switch('--ignore-case')
end

function extension:switchOnlyaFirstResult()
  self:switchWithRequiredValue('--max-count', 1)
end

function extension:newCommand(name, commandTable, useFixedStrings, ignoreCase)
  local command = self:new(name, commandTable)

  if (true == useFixedStrings) then
    command[#command + 1] = '--fixed-strings'
  end

  if (true == ignoreCase) then
    command[#command + 1] = '--ignore-case'
  end

  return command
end

function extension:newGitGrepCommand(useFixedStrings, ignoreCase)
  return self:newCommand('Grep (git)', {
    'git',
    'grep',
    '--color=never',
    '--line-number',
    '--column',
    '-I',
  }, useFixedStrings, ignoreCase)
end

function extension:newRgGrepCommand(useFixedStrings, ignoreCase)
  return self:newCommand('Grep (ripgrep, also in non-vcs files)', {
    'rg',
    '--color=never',
    '--line-number',
    '--column',
    '--smart-case',
    '--no-heading',
    '--no-ignore-vcs',
  }, useFixedStrings, ignoreCase)
end

return extension
