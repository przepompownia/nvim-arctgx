local utils = require 'telescope.utils'

local extension = {}

function extension.top(relativeDir)
  local cmd = {'git', 'rev-parse', '--show-toplevel'}
  local top, exit_code, errors = utils.get_os_command_output(cmd, relativeDir)

  if exit_code > 0 then
    -- vim.notify(table.concat(errors or {}, '\n'), vim.log.levels.ERROR)
    local cwd = vim.loop.cwd()
    vim.notify(string.format(
      'Cannot recognize git top level directory for %s. Using CWD (%s)',
      relativeDir,
      cwd
    ), vim.log.levels.INFO)

    return cwd
  end

  return top[1]
end

function extension.command_files()
  return {'git', 'ls-files'}
end

return extension
