require('arctgx.lazy').setupOnLoad('dap', function ()
  local function skipDisplayingVariable(variable, buf)
    local filetype = vim.bo[buf].filetype
    if variable.name == '$this' and filetype == 'php' then
      return true
    end
    return false
  end

  require('nvim-dap-virtual-text').setup {
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
    display_callback = function (variable, bufId, _stackframe, _node)
      if true == skipDisplayingVariable(variable, bufId) then
        return ''
      end
      -- dap.session():evaluate()

      return variable.name .. ': ' .. variable.value
    end,
  }
end)

local augroup = vim.api.nvim_create_augroup('ArctgxDapVirtualText', {clear = true})
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DAPClean',
  callback = function () require('nvim-dap-virtual-text.virtual_text').clear_virtual_text() end,
})
