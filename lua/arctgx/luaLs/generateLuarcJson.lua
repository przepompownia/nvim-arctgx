--- Generate workspace library for lua-ls respecting runtimepath
--- based on given init file
--- At the project dir run
--- nvim -u ~/.vim/nvim/init.lua -l generateLuarcJson.lua
--- and see .luarc.jsonc as the result

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

    return true
  end, vim.api.nvim_get_runtime_file('', true))

  ---@param value string
  return vim.tbl_map(function (value)
    if not vim.env.NVIM_UNSANDBOXED_CONFIGDIR then
      return value .. '/lua'
    end

    return value:gsub('^' .. vim.fn.stdpath('config'), vim.env.NVIM_UNSANDBOXED_CONFIGDIR, 1) .. '/lua'
  end, paths)
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
  local outputFile = '.luarc.jsonc'
  local paths = listRuntimePaths()

  table.insert(paths, '${3rd}/luv/library')
  table.insert(paths, '${3rd}/luassert/library')
  local staticConfigFile = '.luarc-static.json'
  local staticConfig = tableFromJsonFile(staticConfigFile)
  if nil == staticConfig or nil == staticConfig['workspace'] then
    local modulePath = vim.uv.fs_realpath(debug.getinfo(1).source:match('@?(.*/)') .. '../lsp/serverConfigs/luaLs.lua')
    staticConfig = dofile(modulePath).defaultConfig()
  end
  staticConfig['workspace']['library'] = paths
  local content = vim.json.encode(staticConfig)

  local function printSuccessMessage()
    vim.notify(('Saved result into %s/%s'):format(vim.uv.cwd(), outputFile))
  end

  if 0 == #vim.fn.exepath('jq') then
    write(content, outputFile)
    printSuccessMessage()
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

  printSuccessMessage()
end

generate()
