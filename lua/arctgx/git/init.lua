local git = {}

function git.isTracked(path, gitDir, workTree)
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

function git.top(relativeDir)
  local out = vim.system({'git', 'rev-parse', '--show-toplevel'}, {cwd = relativeDir}):wait()

  if out.code > 0 then
    vim.notify(('Cannot determine top level directory for %s'):format(relativeDir), vim.log.levels.WARN, {title = 'git'})
    return relativeDir or vim.uv.cwd()
  end

  return vim.trim(out.stdout)
end

function git.commandFiles()
  return {'git', 'ls-files'}
end

return git
