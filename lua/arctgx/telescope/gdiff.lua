local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local conf = require('telescope.config').values
local Job = require('plenary.job')
local diff = require('arctgx.git.diff')
local from_entry = require 'telescope.from_entry'
local make_entry = require('telescope.make_entry')
local buffer_previewer = require('telescope.previewers.buffer_previewer')
local sorters = require('telescope.sorters')
local arctgx = require('arctgx.telescope')
local putils = require 'telescope.previewers.utils'

local gdiff = {}

---@param command arctgx.git.diff
---@return function
local function makeRequest(command)
  command:switchNamesOnly()

  return function(query)
    if ('' ~= query) then
      command:setQuery('-S', query)
    else
      command:unsetShortOptionWithValue('-S')
    end
    local job = Job:new({
      args = {unpack(command, 2)},
      sync = true,
      command = command[1]
    })
    job:sync()

    return job:result()
  end
end

---Stolen from telescope
---@param opts table
---@param command arctgx.git.diff
---@return table
local function previewer(opts, command)
  return buffer_previewer.new_buffer_previewer {
    title = 'Git File Diff Preview',
    get_buffer_by_name = function(_, entry) return entry.value end,

    define_preview = function(self, entry, status)
      if entry.status and (entry.status == '??' or entry.status == 'A ') then
        local p = from_entry.path(entry, true)
        if p == nil or p == '' then return end
        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid
        })
      else
        local command = command:clone()
        command:switchNamesOnly(false)
        command:appendArgument(entry.value)
        putils.job_maker(command, self.state.bufnr, {
          value = entry.value,
          bufname = self.state.bufname,
          cwd = opts.cwd
        })
        putils.regex_highlighter(self.state.bufnr, 'diff')
      end
    end
  }
end

function gdiff.run(opts)
  local command = diff:newCommand('GDiff', opts.args or {},
    opts.cwd or vim.loop.cwd())
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'GDiff',
    finder = finders.new_dynamic({
      fn = makeRequest(command),
      entry_maker = make_entry.gen_from_file(opts)
    }),
    sorter = sorters.empty(),
    attach_mappings = function(promptBufnr, map)
      actions.select_default:replace(arctgx.tabDrop)
      return true
    end,
    previewer = previewer(opts, command)
  }):find()
end

return gdiff
