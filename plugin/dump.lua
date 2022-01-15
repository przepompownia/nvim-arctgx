function dump (value)
  local buf = vim.api.nvim_create_buf(false, false)
  -- local value = require('litee.lib.state').get_component_state(vim.api.nvim_win_get_tabpage(0), 'symboltree')

  local value_string = vim.inspect(value):gsub('<function (%d+)>', '"function %1"'):gsub('<%d+>', '')

  local lines = vim.split('out = ' .. value_string, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_open_win(buf, true, {
    relative='editor',
    width=120,
    height=40,
    -- bufpos={0, 0},
    row = 0.9,
    col = 0.9,
    border='rounded',
    style='minimal',
  })

end
