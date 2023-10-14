local M = {}

local function defaultWorkspaceLibrary()
  return {
    vim.env.VIMRUNTIME,
    '${3rd}/luv/library',
  }
end

local function generatedWorkspaceLibrary(root)
  local configPath = root .. '/.lua-ls-workspace-lib.json'
  if not vim.uv.fs_stat(configPath) then
    return nil
  end
  local config = io.open(configPath, 'r')
  if nil == config then
    return nil
  end

  local content = config:read('*a')
  if nil == content or content:len() == 0 then
    return nil
  end

  local _, library = pcall(vim.json.decode, content, {table = {array = true, object = true}})

  if vim.tbl_isarray(library) then
    return library
  end

  return nil
end

--- @param client lsp.Client
--- @return boolean
M.onInit = function (client)
  local path = client.workspace_folders[1].name

  if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
    return true
  end

  vim.notify('.luarc.json(c) not found')
  client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
    Lua = {
      runtime = {
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
          '?.lua',
          '?/init.lua',
        },
        version = 'LuaJIT',
        pathStrict = true,
      },
      workspace = {
        checkThirdParty = false,
        library = generatedWorkspaceLibrary(path) or defaultWorkspaceLibrary(),
        maxPreload = 10000,
        preloadFileSize = 10000,
      },
      window = {
        statusBar = false,
        progressBar = false,
      },
      hint = {
        enable = true,
      },
      diagnostics = {
        unusedLocalExclude = {'_*'},
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
    }
  })

  client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})
end

return M
