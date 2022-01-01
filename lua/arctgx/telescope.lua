local action_state = require 'telescope.actions.state'
local base = require('arctgx.base')
local files = require('arctgx.files')
local finders = require 'telescope.finders'
local git = require('arctgx.git')
local grep = require('arctgx.grep')
local make_entry = require 'telescope.make_entry'
local telescope = require('telescope.builtin')
local transform_mod = require('telescope.actions.mt').transform_mod
local utils = require 'telescope.utils'

local extension = {}

local customActions = transform_mod({
  tabDrop = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selection = picker:get_multi_selection()

    if next(multi_selection) == nil then
      local selected_entry = picker:get_selection()
      -- see from_entry.path
      base.tab_drop(selected_entry.path)

      return
    end

    for _, entry in ipairs(multi_selection) do
      base.tab_drop(entry.path)
    end

    picker.finder:close()
  end,

  toggleCaseSensibility = function() end,
})

extension.customActions = customActions

function extension.create_operator(search_function, cmd, root, title)
  return function (type)
    search_function(
      cmd,
      root,
      base.operator_get_text(type),
      title
    )
  end
end

function extension.grep(cmd, root, query, title)
  -- partial implementation to show that live switching works
  local new_grep_finder = function(new_cmd, prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local current_query = picker:_get_prompt()
    table.insert(new_cmd, '--')
    table.insert(new_cmd, current_query)

    local output = utils.get_os_command_output(new_cmd, root)

    return finders.new_table {
      results = output,
      entry_maker = make_entry.gen_from_vimgrep({}),
    }
  end

  telescope.live_grep({
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    prompt_title = title,
    attach_mappings = function(prompt_bufnr, map)
      customActions.toggleCaseSensibility:enhance {
        post = function()
          table.insert(cmd, '--ignore-case')

          action_state.get_current_picker(prompt_bufnr):refresh(
            new_grep_finder(cmd, prompt_bufnr),
            { reset_prompt = false }
          )
        end,
      }

      map('i', '<CR>', customActions.tabDrop)
      map('n', '<CR>', customActions.tabDrop)
      map('i', '<A-i>', customActions.toggleCaseSensibility)
      map('n', '<A-i>', customActions.toggleCaseSensibility)

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
