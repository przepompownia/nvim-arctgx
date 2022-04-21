local pickers          = require 'telescope.pickers'
local finders          = require 'telescope.finders'
local actions          = require 'telescope.actions'
local action_state     = require 'telescope.actions.state'
local conf             = require('telescope.config').values
local Job              = require('plenary.job')

local Branches = {}

local function listBranches(cwd)
  local list = vim.fn['arctgx#git#listBranches'](cwd, true)
  local result = {}
  for _, entry in ipairs(list) do
    local branch, desc = unpack(vim.split(entry, ';'))
    table.insert(result, {
      branch = branch,
      desc = desc,
    })
  end

  return result
end

local function makeEntry(entry)
  local display = ('%s %s'):format(entry.branch, entry.desc)
  return {
    value = entry,
    display = display,
    ordinal = entry.branch,
  }
end

local function runJob(branch, cwd, noHooks)
  local args = {'-C', cwd, '-c', 'core.hooksPath=', 'checkout', branch}
  local job = Job:new({
    args = args,
    sync = true,
    command = 'git',
  })
  job:sync()

  return job:result()
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
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local branch = selection.value.branch
        runJob(branch, opts.cwd)
      end)
      return true
    end,
  }):find()
end

return Branches
