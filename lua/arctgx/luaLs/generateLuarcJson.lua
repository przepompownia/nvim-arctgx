--- Generate workspace library for lua-ls respecting runtimepath
--- based on given init file
--- At the project dir run
--- nvim -u ~/.vim/nvim/init.lua -l generateLuarcJson.lua
--- and see .luarc.json as the result

local function tableFromJsonFile(jsonFile)
  if not vim.uv.fs_stat(jsonFile) then
    return nil
  end
  local config = io.open(jsonFile, 'r')
  if nil == config then
    return nil
  end

  local content = config:read('*a')
  if nil == content or content:len() == 0 then
    return nil
  end

  local ok, result = pcall(vim.json.decode, content, {table = {array = true, object = true}})

  if not ok then
    print(vim.inspect(result))
    return
  end

  return result
end

local function listRuntimePaths()
  local paths = vim.tbl_filter(function (path)
    if vim.fn.isdirectory(path .. '/lua') ~= 1 then
      return false
    end

    --- Prevent from treat CWD as an element of workspace library
    --- https://github.com/przepompownia/dotnvim/blob/b3f904a81a07045d8cc811b953df6524807623d9/lib/nvim-isolated#L24-L25
    return path ~= vim.uv.cwd() and path ~= vim.env.NVIM_SANDBOXED_CWD
  end, vim.api.nvim_get_runtime_file('', true))

  paths = vim.tbl_map(function (value)
    return value .. '/lua'
  end, paths)

  return paths
end

local function write(text, filename)
  local out = io.open(filename, 'w')
  if nil == out then
    error('Cannot write to ' .. filename)
  end
  out:write(text)
  out:close()
end

local function generate()
  local outputFile = '.luarc.json'
  local paths = listRuntimePaths()
  if nil == paths then
    return
  end
  table.insert(paths, '${3rd}/luv/library')
  local staticConfigFile = '.luarc-static.jsonc'
  local staticConfig = tableFromJsonFile(staticConfigFile)
  if nil == staticConfig or nil == staticConfig['workspace'] then
    return
  end
  staticConfig['workspace']['library'] = paths
  local content = vim.json.encode(staticConfig)

  if 0 == #vim.fn.exepath('jq') then
    write(content, outputFile)
    return
  end

  vim.system({
    'jq', '--sort-keys', '.'
  }, {
    stdin = content,
  }, function (obj)
    if 0 ~= obj.code then
      write(content, outputFile)
      return
    end
    write(obj.stdout, outputFile)
  end):wait()
end

generate()
