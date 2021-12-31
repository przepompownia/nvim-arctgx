local grep = require('arctgx.grep')
local git = require('arctgx.git')
local telescope = require('telescope.builtin')
local files = require('arctgx.files')

local extension = {}

function extension.create_operator(search_function, cmd, root)
  return function (type)
    search_function(
      cmd,
      root,
      vim.fn['arctgx#operator#getText'](type)
    )
  end
end

function extension.grep(cmd, root, query)
  telescope.live_grep({
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    layout_strategy='vertical',
    layout_config={width=0.99},
  })
end

function extension.rg_grep_operator(type)
  return extension.create_operator(
    extension.grep,
    grep.rg_grep_command(true, false),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.git_grep_operator(type)
  return extension.create_operator(
    extension.grep,
    grep.git_grep_command(true, false),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.rg_grep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep.rg_grep_command(useFixedStrings, ignoreCase),
    git.top(vim.fn.expand('%:p:h')),
    query
  )
end

function extension.git_grep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep.git_grep_command(useFixedStrings, ignoreCase),
    git.top(vim.fn.expand('%:p:h')),
    query
  )
end

function extension.files(cmd, root, query)
  telescope.find_files({
    cwd = root,
    layout_strategy='vertical',
    layout_config={width=0.99},
    find_command = cmd,
    default_text = query,
  })
end

function extension.files_git(query)
  extension.files(
    git.command_files(),
    git.top(vim.fn.expand('%:p:h')),
    query
  )
end

function extension.files_git_operator(type)
  return extension.create_operator(
    extension.files,
    git.command_files(),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.files_all_operator(type)
  return extension.create_operator(
    extension.files,
    files.command_fdfind_all(),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.files_all(query)
  extension.files(
    files.command_fdfind_all(),
    git.top(vim.fn.expand('%:p:h')),
    query
  )
end

return extension
