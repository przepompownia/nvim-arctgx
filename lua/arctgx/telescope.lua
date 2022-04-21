local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local base = require('arctgx.base')
local files = require('arctgx.files')
local git = require('arctgx.git')
---@class Grep
local grep = require('arctgx.grep')
local telescope = require('telescope.builtin')
local transform_mod = require('telescope.actions.mt').transform_mod
local branches      = require('arctgx.telescope.branches')

local extension = {}

local customActions = transform_mod({
  tabDrop = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selection = picker:get_multi_selection()

    if next(multi_selection) == nil then
      local selected_entry = picker:get_selection()
      -- see from_entry.path
      base.tab_drop(
        selected_entry.path,
        selected_entry.lnum,
        selected_entry.col,
        picker.original_win_id
      )

      vim.cmd('stopinsert')
      picker.finder:close()
      return
    end

    for _, entry in ipairs(multi_selection) do
      base.tab_drop(entry.path)
    end

    vim.cmd('stopinsert')
    picker.finder:close()
    vim.api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  end,

  toggleCaseSensibility = function() end,
  toggleFixedStrings = function() end,
})

local defaultFileMappings = function(prompt_bufnr, map)
  map('i', '<CR>', customActions.tabDrop)
  map('n', '<CR>', customActions.tabDrop)
  map('n', '<C-y>', actions.file_edit)
  map('i', '<C-y>', actions.file_edit)

  return true
end

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

function extension.branches()
  branches.list({cwd = git.top(vim.fn.expand('%:p:h'))})
end

function extension.oldfiles()
  telescope.oldfiles({
    attach_mappings = defaultFileMappings,
  })
end

function extension.buffers()
  telescope.buffers({
    attach_mappings = defaultFileMappings,
  })
end

---@param cmd Grep
---@param root string
---@param query string
function extension.grep(cmd, root, query)
  local new_grep_finder = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    return picker.finder
  end
  local refreshPicker = function(prompt_bufnr, command)
    local picker = action_state.get_current_picker(prompt_bufnr)

    picker:refresh(new_grep_finder(prompt_bufnr), { reset_prompt = false })
    picker.prompt_border:change_title(command:status())
  end

  telescope.live_grep({
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    prompt_title = cmd:status(),
    attach_mappings = function(prompt_bufnr, map)
      customActions.toggleCaseSensibility:enhance {
        post = function()
          cmd:switch_case_sensibility()
          refreshPicker(prompt_bufnr, cmd)
        end,
      }
      customActions.toggleFixedStrings:enhance {
        post = function()
          cmd:switch_fixed_strings()
          refreshPicker(prompt_bufnr, cmd)
        end,
      }

      defaultFileMappings(prompt_bufnr, map)
      map('i', '<A-i>', customActions.toggleCaseSensibility)
      map('n', '<A-i>', customActions.toggleCaseSensibility)
      map('i', '<A-f>', customActions.toggleFixedStrings)
      map('n', '<A-f>', customActions.toggleFixedStrings)

      return true
    end,
  })
end

function extension.rg_grep_operator(type)
  return extension.create_operator(
    extension.grep,
    grep:new_rg_grep_command(true, false),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.git_grep_operator(type)
  return extension.create_operator(
    extension.grep,
    grep:new_git_grep_command(true, false),
    git.top(vim.fn.expand('%:p:h'))
  )(type)
end

function extension.rgGrep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep:new_rg_grep_command(useFixedStrings, ignoreCase),
    git.top(vim.fn.expand('%:p:h')),
    query
  )
end

function extension.gitGrep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep:new_git_grep_command(useFixedStrings, ignoreCase),
    git.top(vim.fn.expand('%:p:h')),
    query
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

function extension.filesGit(query)
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

function extension.filesAll(query)
  extension.files(
    files.command_fdfind_all(),
    git.top(vim.fn.expand('%:p:h')),
    query,
    'Files (all)'
  )
end

return extension
