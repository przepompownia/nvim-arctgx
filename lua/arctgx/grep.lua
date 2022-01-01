local extension = {}

function extension.git_grep_command(useFixedStrings, ignoreCase)
  local command = {
    'git',
    'grep',
    '--color=never',
    '--line-number',
    '--column',
    '-I',
  }

  if (true == useFixedStrings) then
    table.insert(command, '--fixed-strings')
  end

  if (true == ignoreCase) then
    table.insert(command, '--ignore-case')
  end

  return command
end

function extension.rg_grep_command(useFixedStrings, ignoreCase)
  local command = {
    'rg',
    '--color=never',
    '--line-number',
    '--column',
    '--smart-case',
    '--no-heading',
  }

  if (true == useFixedStrings) then
    table.insert(command, '--fixed-strings')
  end

  if (true == ignoreCase) then
    table.insert(command, '--ignore-case')
  end

  return command
end

return extension
