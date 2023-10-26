local api = vim.api
-- local dap = require('dap')
local virtualText = require('nvim-dap-virtual-text')

---@param variable any
---@param buf any
---@return boolean
local function skipDisplayingVariable(variable, buf)
  local filetype = vim.bo[buf].filetype
  if variable.name == '$this' and filetype == 'php' then
    return true
  end
  return false
end

virtualText.setup {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = false,
  all_references = true,
  filter_references_pattern = '<module',
  -- virt_text_pos = 'eol',
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
  display_callback = function(variable, bufId, stackframe, node)
    if true == skipDisplayingVariable(variable, bufId) then
      return ''
    end
    -- dap.session():evaluate()

    return variable.name .. ': ' .. variable.value
  end,
}

local augroup = api.nvim_create_augroup('ArctgxDapVirtualText', {clear = true})
api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DAPClean',
  callback = virtualText.refresh,
})
