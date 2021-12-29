local extension = {}

function extension.git_grep_command(useFixedStrings, ignoreCase)
  local command = {
    'git',
    'grep',
    '--fixed-strings',
    '--color=never',
    '--line-number',
    '--column',
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
    '--fixed-strings',
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

function extension.create_operator(grep_function, cmd, root)
  return function (type)
    grep_function(
      cmd,
      root,
      vim.fn['arctgx#operator#getText'](type)
    )
  end
end

return extension
