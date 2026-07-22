local Json = {}

---@return table?
function Json.fromFile(jsonFile)
  if not vim.uv.fs_stat(jsonFile) then
    return nil
  end
  local config = io.open(jsonFile, 'r')
  if nil == config then
    return nil
  end

  local content = config:read('*a')
  config:close()

  if nil == content or content:len() == 0 then
    return nil
  end

  local ok, result = pcall(vim.json.decode, content, {table = {array = true, object = true}})

  if not ok then
    vim.notify(vim.inspect(result), vim.log.levels.ERROR)
    return
  end

  return result
end

return Json
