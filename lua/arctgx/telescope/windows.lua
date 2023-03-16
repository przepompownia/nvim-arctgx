local pickers          = require 'telescope.pickers'
local finders          = require 'telescope.finders'
local actions          = require 'telescope.actions'
local action_state     = require 'telescope.actions.state'
local conf             = require('telescope.config').values
local buffer_previewer = require('telescope.previewers.buffer_previewer')

---@class arctgx.telescope.windows
local Windows = {}

local function listBufferWindowPairs()
  local result = {}
  for _, winId in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winId))
    table.insert(result, {
      bufname = bufname,
      winId = winId,
    })
  end

  return result
end

local function makeEntry(entry)
  local ok, _ = vim.loop.fs_stat(entry.bufname)
  local relativePath
  if ok then
    relativePath = vim.fn.fnamemodify(entry.bufname, ':.')
  end
  local display = ('%s %s'):format(entry.winId, relativePath or entry.bufname)
  return {
    value = entry,
    display = display,
    ordinal = display,
  }
end

---@diagnostic disable-next-line: unused-local, unused-function
local function previewer()
  return buffer_previewer.new_buffer_previewer {
    title = 'Window content',
    get_buffer_by_name = function(_, entry)
      return entry.value.bufname
    end,

    define_preview = function(self, entry)
      conf.buffer_previewer_maker(entry.value.bufname, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
      })
    end,
  }
end

function Windows.list(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'Windows',
    finder = finders.new_table({
      results = listBufferWindowPairs(),
      entry_maker = makeEntry,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if nil == selection then
          return
        end
        vim.api.nvim_set_current_win(selection.value.winId)
      end)
      return true
    end,
    -- previewer = previewer(opts, command)
  }):find()
end

return Windows
