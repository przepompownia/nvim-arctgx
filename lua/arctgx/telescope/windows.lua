local api = vim.api

--- @class arctgx.telescope.windows
local Windows = {}

local function listBufferWindowPairs()
  local result = {}
  for _, winId in ipairs(api.nvim_list_wins()) do
    local bufname = api.nvim_buf_get_name(api.nvim_win_get_buf(winId))
    result[# result + 1] = {
      bufname = bufname,
      winId = winId,
    }
  end

  return result
end

local function makeEntry(entry)
  local ok, _ = vim.uv.fs_stat(entry.bufname)
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

--- @diagnostic disable-next-line: unused-local, unused-function
local function previewer()
  return require('telescope.previewers.buffer_previewer').new_buffer_previewer {
    title = 'Window content',
    get_buffer_by_name = function (_, entry)
      return entry.value.bufname
    end,

    define_preview = function (self, entry)
      require('telescope.config').values.buffer_previewer_maker(entry.value.bufname, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
      })
    end,
  }
end

function Windows.list(opts)
  local actions = require 'telescope.actions'
  opts = opts or {}
  require('telescope.pickers').new(opts, {
    prompt_title = 'Windows',
    finder = require('telescope.finders').new_table({
      results = listBufferWindowPairs(),
      entry_maker = makeEntry,
    }),
    sorter = require('telescope.config').values.generic_sorter(opts),
    attach_mappings = function (prompt_bufnr, _map)
      actions.select_default:replace(function ()
        actions.close(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        if nil == selection then
          return
        end
        api.nvim_set_current_win(selection.value.winId)
      end)
      return true
    end,
    -- previewer = previewer(opts, command)
  }):find()
end

return Windows
