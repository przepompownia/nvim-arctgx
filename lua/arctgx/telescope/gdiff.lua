local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local diff = require('arctgx.git.diff')
local fromEntry = require 'telescope.from_entry'
local makeEntry = require('telescope.make_entry')
local bufferPreviewer = require('telescope.previewers.buffer_previewer')
local sorters = require('telescope.sorters')
local putils = require 'telescope.previewers.utils'
local telescope = require 'arctgx.telescope'

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
    local job = require('plenary.job'):new({
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
  return bufferPreviewer.new_buffer_previewer {
    title = 'Git File Diff Preview',
    get_buffer_by_name = function(_, entry) return entry.value end,

    define_preview = function(self, entry, status)
      if entry.status and (entry.status == '??' or entry.status == 'A ') then
        local p = fromEntry.path(entry, true)
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
    opts.cwd or vim.uv.cwd())
  opts = opts or {}
  require('telescope.pickers').new(opts, {
    prompt_title = 'GDiff',
    finder = finders.new_dynamic({
      fn = makeRequest(command),
      entry_maker = makeEntry.gen_from_file(opts)
    }),
    sorter = sorters.empty(),
    attach_mappings = telescope.defaultFileMappings,
    previewer = previewer(opts, command)
  }):find()
end

return gdiff
