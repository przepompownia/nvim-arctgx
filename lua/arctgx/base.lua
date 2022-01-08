local extension = {}

function extension.tab_drop(path, line, column)
  vim.fn['arctgx#base#tabDrop'](path)
  vim.api.nvim_win_set_cursor(0, {line, column})
end

function extension.operator_get_text(type)
  return vim.fn['arctgx#operator#getText'](type)
end

return extension
