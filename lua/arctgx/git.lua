local utils = require 'telescope.utils'

local extension = {}

function extension.top(relative_dir)
  local cmd = {'git', 'rev-parse', '--show-toplevel'}
  local top, exit_code, errors = utils.get_os_command_output(cmd, relative_dir)

  if exit_code > 0 then
    print(table.concat(errors, '\n'))
    local cwd = vim.loop.cwd()
    print(string.format('Using cwd (%s)', cwd))

    return cwd
  end

  return top[1]
end

function extension.command_files()
  return {'git', 'ls-files'}
end

return extension
