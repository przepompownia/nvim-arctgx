local pickers      = require 'telescope.pickers'
local finders      = require 'telescope.finders'
local actions      = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf         = require('telescope.config').values
local Job          = require('plenary.job')
local diff         = require('arctgx.git.diff')
local make_entry   = require('telescope.make_entry')
local base         = require('arctgx.base')
local gdiff        = {}

local function makeRequest(bufnr, opts)
  local command = diff:newCommand(
    'xx',
    opts.args or {},
    opts.cwd or vim.loop.cwd()
  )
  command:switchNamesOnly()

  return function(query)
    if ('' ~= query) then
      command:setQuery('-S', query)
    end
    local job = Job:new({
      args = {unpack(command, 2)},
      sync = true,
      command = command[1],
    })
    job:sync()

    return job:result()
  end
end

function gdiff.run(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'GDiff',
    finder = finders.new_dynamic({
      fn = makeRequest(opts.bufnr, opts),
      entry_maker = make_entry.gen_from_file(opts),
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local result = selection[1]
        base.tab_drop(result)
      end)
      return true
    end,
  }):find()
end

return gdiff
