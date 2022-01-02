local extension = {}

function extension:new(list)
  setmetatable(list, self)
  self.__index = self

  return list
end

function extension:switch(x)
  for k, v in ipairs(self) do
    if v == x then
      table.remove(self, k)
      return
    end
  end

  table.insert(self, x)
end

function extension:switch_fixed_strings()
  self:switch('--fixed-strings')
end

function extension:switch_case_sensibility()
  self:switch('--ignore-case')
end

function extension:new_command(commandTable, useFixedStrings, ignoreCase)
  local command = self:new(commandTable)

  if (true == useFixedStrings) then
    table.insert(command, '--fixed-strings')
  end

  if (true == ignoreCase) then
    table.insert(command, '--ignore-case')
  end

  return command
end

function extension:new_git_grep_command(useFixedStrings, ignoreCase)
  return self:new_command({
    'git',
    'grep',
    '--color=never',
    '--line-number',
    '--column',
    '-I',
  }, useFixedStrings, ignoreCase)
end

function extension:new_rg_grep_command(useFixedStrings, ignoreCase)
  return self:new_command({
    'rg',
    '--color=never',
    '--line-number',
    '--column',
    '--smart-case',
    '--no-heading',
  }, useFixedStrings, ignoreCase)
end

return extension
