local M = {}

local function defaultWorkspaceLibrary()
  return {
    vim.env.VIMRUNTIME,
    '${3rd}/luv/library',
  }
end

local function generatedWorkspaceLibrary()
  return nil
end

M.onInit = function (client)
  local path = client.workspace_folders[1].name

  if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
    return true
  end

  vim.notify('.luarc.json(c) not found')
  client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
    Lua = {
      runtime = {
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
        version = 'LuaJIT',
        pathStrict = true,
      },
      workspace = {
        checkThirdParty = false,
        library = generatedWorkspaceLibrary() or defaultWorkspaceLibrary(),
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
        unusedLocalExclude = '_*',
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
    }
  })

  client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})
end

return M
