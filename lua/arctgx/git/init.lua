local extension = {}

function extension.isTracked(path, gitDir, workTree)
  local cmd = {
    'git',
    '--git-dir', gitDir,
    '--work-tree', workTree,
    'ls-files',
    '--error-unmatch',
    path,
  }
  local obj = vim.system(cmd):wait()

  return 0 == obj.code
end

return extension
