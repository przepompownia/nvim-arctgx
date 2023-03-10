local actions = require('telescope.actions')
local action_state = require 'telescope.actions.state'
local base = require('arctgx.base')
local files = require('arctgx.files')
local git = require('arctgx.git')
---@class Grep
local grep = require('arctgx.grep')
local telescope = require('telescope.builtin')
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local transform_mod = require('telescope.actions.mt').transform_mod
local branches = require('arctgx.telescope.branches')
local utils = require 'telescope.utils'

local extension = {}

local function tabDropEntry(entry, winId)
  local path = entry.path or vim.fn.expand(entry.filename)
  vim.cmd('stopinsert')
  base.tab_drop(path, entry.lnum, entry.col, winId)

  vim.api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
end

function extension.tabDrop(promptBufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    utils.__warn_no_selection 'actions.tabDrop'
    return
  end

  local picker = action_state.get_current_picker(promptBufnr)
  local winId = picker.original_win_id
  local multiSelection = picker:get_multi_selection()
  actions.close(promptBufnr)

  if next(multiSelection) == nil then
    local selectedEntry = picker:get_selection()
    tabDropEntry(selectedEntry, winId)
    return
  end

  for _, entry in ipairs(multiSelection) do tabDropEntry(entry, winId) end
end

local customActions = transform_mod({
  tabDrop = extension.tabDrop,

  toggleCaseSensibility = function() end,
  toggleFixedStrings = function() end,
  toggleOnlyFirstResult = function() end
})

extension.customActions = customActions

function extension.defaultFileMappings(prompt_bufnr, map)
  actions.select_default:replace(customActions.tabDrop)
  map({'i', 'n'}, '<C-y>', actions.file_edit)
  map({'i', 'n'}, '<A-u>', actions.to_fuzzy_refine)

  return true
end

function extension.create_operator(search_function, cmd, root, title)
  return function(type)
    search_function(cmd, root, base.operator_get_text(type), title)
  end
end

function extension.branches(opts)
  branches.list(vim.tbl_deep_extend('keep', opts or {}, {cwd = git.top(base.getBufferCwd())}))
end

---@param onlyCwd boolean
function extension.oldfiles(onlyCwd)
  telescope.oldfiles({
    only_cwd = onlyCwd or false,
    attach_mappings = extension.defaultFileMappings,
  })
end

function extension.buffers()
  telescope.buffers({attach_mappings = extension.defaultFileMappings})
end

---@param cmd Grep
---@param root string
---@param query string
function extension.grep(cmd, root, query)
  local opts = {
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    prompt_title = cmd:status(),
  }
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "v", true)
  opts.finder = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    local search_dirs = opts.search_dirs
    local search_list = {}

    if search_dirs then
      search_list = search_dirs
    end

    return vim.tbl_flatten { cmd, "--", prompt, search_list }
    end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  local new_grep_finder = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    return picker.finder
  end
  local refreshPicker = function(prompt_bufnr, command)
    local picker = action_state.get_current_picker(prompt_bufnr)

    picker:refresh(new_grep_finder(prompt_bufnr), {reset_prompt = false})
    picker.prompt_border:change_title(command:status())
  end

  opts.attach_mappings = function(prompt_bufnr, map)
      customActions.toggleCaseSensibility:enhance {
        post = function()
          cmd:switch_case_sensibility()
          refreshPicker(prompt_bufnr, cmd)
        end
      }
      customActions.toggleFixedStrings:enhance {
        post = function()
          cmd:switch_fixed_strings()
          refreshPicker(prompt_bufnr, cmd)
        end
      }
      customActions.toggleOnlyFirstResult:enhance {
        post = function()
          cmd:switch_only_first_result()
          refreshPicker(prompt_bufnr, cmd)
        end
      }

      extension.defaultFileMappings(prompt_bufnr, map)
      map({'i', 'n'}, '<A-i>', customActions.toggleCaseSensibility)
      map({'i', 'n'}, '<A-f>', customActions.toggleFixedStrings)
      map({'i', 'n'}, '<A-o>', customActions.toggleOnlyFirstResult)

      return true
    end

  telescope.live_grep(opts)
end

function extension.rg_grep_operator(type)
  return extension.create_operator(
    extension.grep,
    grep:new_rg_grep_command(true, false),
    git.top(base.getBufferCwd())
  )(type)
end

function extension.git_grep_operator(type)
  return extension.create_operator(
    extension.grep,
    grep:new_git_grep_command(true, false),
    git.top(base.getBufferCwd())
  )(type)
end

function extension.rgGrep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep:new_rg_grep_command(useFixedStrings, ignoreCase),
    git.top(base.getBufferCwd()),
    query
  )
end

function extension.gitGrep(query, useFixedStrings, ignoreCase)
  return extension.grep(
    grep:new_git_grep_command(useFixedStrings, ignoreCase),
    git.top(base.getBufferCwd()),
    query
  )
end

function extension.files(cmd, root, query, title)
  telescope.find_files({
    cwd = root,
    find_command = cmd,
    default_text = query,
    prompt_title = title,
    attach_mappings = extension.defaultFileMappings,
  })
end

function extension.filesGit(query)
  extension.files(git.command_files(), git.top(base.getBufferCwd()), query,
    'Files (git)')
end

function extension.files_git_operator(type)
  return extension.create_operator(extension.files, git.command_files(),
    git.top(base.getBufferCwd()), 'Files (git)')(
    type)
end

function extension.files_all_operator(type)
  return extension.create_operator(extension.files,
    files.command_fdfind_all(),
    git.top(base.getBufferCwd()), 'Files (all)')(
    type)
end

function extension.filesAll(query)
  extension.files(files.command_fdfind_all(), git.top(base.getBufferCwd()),
    query, 'Files (all)')
end

return extension
