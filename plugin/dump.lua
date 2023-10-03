function dump(value)
  vim.schedule(function ()
    local buf = vim.api.nvim_create_buf(false, true)

    local value_string = vim.inspect(value):gsub('<function (%d+)>', '"function %1"'):gsub('<%d+>', '')

    local lines = vim.split('out = ' .. value_string, '\n')
    vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)
    vim.treesitter.start(buf, 'lua')
    vim.bo[buf].bufhidden = 'wipe'
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = 120,
      height = #lines,
      row = 0.9,
      col = 0.9,
      border = 'rounded',
      style = 'minimal',
    })
  end)
end
