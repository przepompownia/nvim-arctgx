local extension = {}

function extension.tab_drop(path)
  return vim.fn['arctgx#base#tabDrop'](path)
end

function extension.operator_get_text(type)
  return vim.fn['arctgx#operator#getText'](type)
end

return extension
