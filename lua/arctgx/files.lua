local extension = {}

function extension.command_fdfind_all()
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
