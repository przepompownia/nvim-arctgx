local function explodePath(path)
  local line = 1
  local column = 1
  local separator = ':'
  local params = {}

  if not path or not path:find(separator) then
    return path, line, column
  end

  local parts = vim.split(path, separator, {plain = true})
  local length = #parts
  for i = length, 1, -1 do
    if i < length - 1 or not parts[i]:match('^%d+$') then
      break
    end
    params[#params + 1] = tonumber(table.remove(parts, i))
  end

  assert(#params < 3)
  line = table.remove(params)
  column = table.remove(params) or 1

  return table.concat(parts, separator), line, column
end

vim.api.nvim_create_user_command('E', function (opts)
  local args = opts.fargs
  ---@type string
  local path, line, column = explodePath(table.remove(args, 1))
  require('arctgx.base').editMappedPath(path, line, column)
end, {nargs = '*', complete = 'file'})
