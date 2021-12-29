local grep = require('arctgx/grep')
local git = require('arctgx/git')

local extension = {}

function extension.grep(cmd, root, query)
  require('telescope.builtin').live_grep({
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    layout_strategy='vertical',
    layout_config={width=0.99},
  })
end

function extension.rg_grep_operator(type)
  return grep.create_operator(
    extension.grep,
    grep.rg_grep_command(true, false),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.git_grep_operator(type)
  return grep.create_operator(
    extension.grep,
    grep.git_grep_command(true, false),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

return extension
