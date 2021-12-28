local extension = {}

function extension.git_grep_command()
  return {'git', 'grep', '--fixed-strings', '--color=never', '--line-number', '--column'}
end

function extension.rg_grep_command()
  return {'rg', '--fixed-strings', '--color=never', '--line-number', '--column', '--smart-case', '--no-heading'}
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
