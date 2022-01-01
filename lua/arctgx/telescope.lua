local action_set = require 'telescope.actions.set'
local files = require('arctgx.files')
local git = require('arctgx.git')
local grep = require('arctgx.grep')
local telescope = require('telescope.builtin')
local transform_mod = require('telescope.actions.mt').transform_mod

local extension = {}

local customActions = transform_mod({
  tabDrop = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, 'TabDrop')
  end,
})

extension.customActions = customActions

function extension.create_operator(search_function, cmd, root, title)
  return function (type)
    search_function(
      cmd,
      root,
      vim.fn['arctgx#operator#getText'](type),
      title
    )
  end
end

function extension.grep(cmd, root, query, title)
  telescope.live_grep({
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    prompt_title = title,
    attach_mappings = function(_, map)
      map('i', '<CR>', customActions.tabDrop)
      map('n', '<CR>', customActions.tabDrop)

      return true
    end,
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
    query,
    'Grep (rg)'
  )
end

function extension.git_grep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep.git_grep_command(useFixedStrings, ignoreCase),
    git.top(vim.fn.expand('%:p:h')),
    query,
    'Grep (git)'
  )
end

function extension.files(cmd, root, query, title)
  telescope.find_files({
    cwd = root,
    find_command = cmd,
    default_text = query,
    prompt_title = title,
    attach_mappings = function(_, map)
      map('i', '<CR>', customActions.tabDrop)
      map('n', '<CR>', customActions.tabDrop)

      return true
    end,
  })
end

function extension.files_git(query)
  extension.files(
    git.command_files(),
    git.top(vim.fn.expand('%:p:h')),
    query,
    'Files (git)'
  )
end

function extension.files_git_operator(type)
  return extension.create_operator(
    extension.files,
    git.command_files(),
    git.top(vim.fn.expand('%:p:h')),
    'Files (git)'
  )(type)
end

function extension.files_all_operator(type)
  return extension.create_operator(
    extension.files,
    files.command_fdfind_all(),
    git.top(vim.fn.expand('%:p:h')),
    'Files (all)'
  )(type)
end

function extension.files_all(query)
  extension.files(
    files.command_fdfind_all(),
    git.top(vim.fn.expand('%:p:h')),
    query,
    'Files (all)'
  )
end

return extension
