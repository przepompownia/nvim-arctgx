local utils = require 'telescope.utils'

local extension = {}

function extension.top(relative_dir)
  local cmd = {'git', 'rev-parse', '--show-toplevel'}
  local top, exit_code, errors = utils.get_os_command_output(cmd, relative_dir)

  if exit_code > 0 then
    print(table.concat(errors), '\n')
  end

  return top[1]
end

return extension
