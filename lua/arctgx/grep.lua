local extension = {}

function extension:new(name, list)
  setmetatable(list, self)
  self.__index = self
  self.name = name

  return list
end

function extension:index_of(element)
  for k, v in ipairs(self) do
    if v == element then
      return k
    end
  end
end

function extension:switch(option)
  local key = self:index_of(option)
  if key then
    table.remove(self, key)
    return
  end

  table.insert(self, option)
end

function extension:switchWithRequiredValue(option, value)
  local key = self:index_of(option)
  if key then
    table.remove(self, key)
    table.remove(self, key)
    return
  end

  table.insert(self, option)
  table.insert(self, value)
end

---@return string
function extension:status()
  local settings = {}
  table.insert(settings, self:index_of('--fixed-strings') and 'Fixed strings' or 'Regex')
  table.insert(settings, 'Case ' .. (self:index_of('--ignore-case') and 'insensitive' or 'sensitive'))
  table.insert(settings, (self:index_of('--max-count') and 'Only first result' or nil))
  return ('%s: %s'):format(self.name, table.concat(settings, ', '))
end

function extension:switch_fixed_strings()
  self:switch('--fixed-strings')
end

function extension:switch_case_sensibility()
  self:switch('--ignore-case')
end

function extension:switch_only_first_result()
  self:switchWithRequiredValue('--max-count', 1)
end

function extension:new_command(name, commandTable, useFixedStrings, ignoreCase)
  local command = self:new(name, commandTable)

  if (true == useFixedStrings) then
    table.insert(command, '--fixed-strings')
  end

  if (true == ignoreCase) then
    table.insert(command, '--ignore-case')
  end

  return command
end

function extension:new_git_grep_command(useFixedStrings, ignoreCase)
  return self:new_command('Grep (git)', {
    'git',
    'grep',
    '--color=never',
    '--line-number',
    '--column',
    '-I',
  }, useFixedStrings, ignoreCase)
end

function extension:new_rg_grep_command(useFixedStrings, ignoreCase)
  return self:new_command('Grep (rg)', {
    'rg',
    '--color=never',
    '--line-number',
    '--column',
    '--smart-case',
    '--no-heading',
  }, useFixedStrings, ignoreCase)
end

return extension
