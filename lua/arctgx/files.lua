local extension = {}

function extension.commandFdfindAll()
  return {
    'fdfind',
    '--hidden',
    '--exclude', '.git',
    '--color=never',
    '--no-ignore-vcs',
    '--full-path',
    '--type=file',
  }
end

return extension
