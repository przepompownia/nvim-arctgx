local api = vim.api
local pickers          = require 'telescope.pickers'
local finders          = require 'telescope.finders'
local actions          = require 'telescope.actions'
local action_state     = require 'telescope.actions.state'
local conf             = require('telescope.config').values
local Job              = require('plenary.job')
local utils            = require('telescope.utils')

local Branches = {}

local function listBranches(cwd)
  local list = vim.fn['arctgx#git#listBranches'](cwd, true)
  local result = {}
  for _, entry in ipairs(list) do
    local head, branch, desc = unpack(vim.split(entry, ';'))
    table.insert(result, 1, {
      branch = branch,
      desc = desc,
      head = head,
    })
  end

  return result
end

local function makeEntry(entry)
  local display = ('%s %s %s'):format(entry.head, entry.branch, entry.desc)
  return {
    value = entry,
    display = display,
    ordinal = entry.branch,
  }
end

local function switchToBranch(branch, cwd, noHooks)
  local cmd = {'git', '-c', 'core.hooksPath=', 'switch', branch}
  local stdout, exitCode, stderr = utils.get_os_command_output(cmd, cwd)

  if {} ~= stderr then
    vim.notify(table.concat(stderr, '\n'), vim.log.levels.WARN)
  end

  if 0 ~= exitCode then
    return
  end
  vim.schedule(function ()
    api.nvim_cmd({cmd = 'checktime'}, {})
    api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  end)
end

function Branches.list(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'Git branches',
    finder = finders.new_table({
      results = listBranches(opts.cwd),
      entry_maker = makeEntry,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local branch = selection.value.branch
        switchToBranch(branch, opts.cwd)
      end)
      return true
    end,
  }):find()
end

return Branches
