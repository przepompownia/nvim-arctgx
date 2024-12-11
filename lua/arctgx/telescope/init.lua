local base = require('arctgx.base')
local git = require('arctgx.git')

local extension = {}

--- @param promptBufnr integer
--- @param callback function({bufnr: integer}, Picker)
local function callOnSelection(promptBufnr, callback, actionName)
  local actionState = require 'telescope.actions.state'
  local selection = actionState.get_selected_entry()
  if selection == nil then
    require('telescope.utils').__warn_no_selection(actionName)
    return
  end

  ---@type Picker
  local picker = actionState.get_current_picker(promptBufnr)
  local multiSelection = picker:get_multi_selection()
  local actions = require('telescope.actions')
  actions.close(promptBufnr)

  if next(multiSelection) == nil then
    local selectedEntry = picker:get_selection()
    callback(selectedEntry, picker)
    return
  end

  for _, entry in ipairs(multiSelection) do callback(entry, picker) end
end

local customActions = nil

function extension.customActions()
  if customActions then
    return customActions
  end
  local ok, mt = pcall(require, 'telescope.actions.mt')
  if not ok then
    return
  end

  customActions = mt.transform_mod({
    toggleCaseSensibility = function () end,
    toggleFixedStrings = function () end,
    toggleOnlyFirstResult = function () end,
  })

  return customActions
end

function extension.defaultFileMappings(_promptBufnr, map)
  local ok, actions = pcall(require, 'telescope.actions')
  if not ok then
    return true
  end

  map({'i', 'n'}, '<C-y>', actions.file_edit)
  map({'i', 'n'}, '<A-u>', actions.to_fuzzy_refine)

  return true
end

function extension.createOperator(searchFunction, cmd, root, title)
  return function (_type)
    local str = vim.iter(vim.fn.getregion(vim.fn.getpos('\'['), vim.fn.getpos('\']'))):next() or ''

    searchFunction(cmd, root, str, title)
  end
end

--- @param onlyCwd boolean
function extension.oldfiles(onlyCwd)
  require('telescope.builtin').oldfiles({
    only_cwd = onlyCwd or false,
    attach_mappings = extension.defaultFileMappings,
  })
end

--- @param cmd Grep
--- @param root string
--- @param query string
function extension.grep(cmd, root, query)
  if query:find('\n') then
    vim.notify('Cannot grep multiline text', vim.log.levels.WARN, {title = 'Telescope grep extension'})

    return
  end
  local actionState = require 'telescope.actions.state'
  local opts = {
    cwd = root,
    default_text = query,
    grep_open_files = false,
    vimgrep_arguments = cmd,
    prompt_title = cmd:status(),
  }

  opts.finder = require('telescope.finders').new_job(function (prompt)
    if not prompt or prompt == '' then
      return nil
    end

    local search_dirs = opts.search_dirs
    local search_list = {}

    if search_dirs then
      search_list = search_dirs
    end

    return vim.iter({cmd, '--', prompt, search_list}):flatten():totable()
  end, opts.entry_maker or require('telescope.make_entry').gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  local newGrepFinder = function (promptBufnr)
    local picker = actionState.get_current_picker(promptBufnr)
    return picker.finder
  end
  local refreshPicker = function (promptBufnr, command)
    local picker = actionState.get_current_picker(promptBufnr)

    picker:refresh(newGrepFinder(promptBufnr), {reset_prompt = false})
    picker.prompt_border:change_title(command:status())
  end

  opts.attach_mappings = function (promptBufnr, map)
    extension.customActions().toggleCaseSensibility:enhance {
      post = function ()
        cmd:switchCaseSensibility()
        refreshPicker(promptBufnr, cmd)
      end
    }
    extension.customActions().toggleFixedStrings:enhance {
      post = function ()
        cmd:switchFixedStrings()
        refreshPicker(promptBufnr, cmd)
      end
    }
    extension.customActions().toggleOnlyFirstResult:enhance {
      post = function ()
        cmd:switchOnlyaFirstResult()
        refreshPicker(promptBufnr, cmd)
      end
    }

    extension.defaultFileMappings(promptBufnr, map)
    map({'i', 'n'}, '<A-i>', extension.customActions().toggleCaseSensibility)
    map({'i', 'n'}, '<A-f>', extension.customActions().toggleFixedStrings)
    map({'i', 'n'}, '<A-o>', extension.customActions().toggleOnlyFirstResult)

    return true
  end

  require('telescope.builtin').live_grep(opts)
end

function extension.rgGrepOperator(type)
  return extension.createOperator(
    extension.grep,
    require('arctgx.grep'):newRgGrepCommand(true, false),
    git.top(base.getBufferCwd())
  )(type)
end

function extension.gitGrepOperator(type)
  return extension.createOperator(
    extension.grep,
    require('arctgx.grep'):newGitGrepCommand(true, false),
    git.top(base.getBufferCwd())
  )(type)
end

function extension.rgGrep(query, root, useFixedStrings, ignoreCase)
  vim.validate('root dir', root, {'string', 'nil'})
  return extension.grep(
    require('arctgx.grep'):newRgGrepCommand(useFixedStrings, ignoreCase),
    root or git.top(base.getBufferCwd()),
    query
  )
end

function extension.gitGrep(query, root, useFixedStrings, ignoreCase)
  vim.validate('root dir', root, {'string', 'nil'})
  return extension.grep(
    require('arctgx.grep'):newGitGrepCommand(useFixedStrings, ignoreCase),
    root or git.top(base.getBufferCwd()),
    query
  )
end

function extension.files(cmd, root, query, title)
  require('telescope.builtin').find_files({
    cwd = root,
    find_command = cmd,
    default_text = query,
    prompt_title = title,
    attach_mappings = extension.defaultFileMappings,
  })
end

function extension.filesGit(query)
  extension.files(
    git.commandFiles(),
    git.top(base.getBufferCwd()),
    query,
    'Files (git)'
  )
end

function extension.filesGitOperator(type)
  return extension.createOperator(
    extension.files,
    git.commandFiles(),
    git.top(base.getBufferCwd())
  )(type)
end

function extension.filesAllOperator(type)
  return extension.createOperator(
    extension.files,
    require('arctgx.files').commandFdfindAll(),
    git.top(base.getBufferCwd())
  )(type)
end

function extension.filesAll(query)
  extension.files(
    require('arctgx.files').commandFdfindAll(),
    git.top(base.getBufferCwd()),
    query,
    'Files (all)'
  )
end

return extension
