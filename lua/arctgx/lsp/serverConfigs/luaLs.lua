local M = {}

local function defaultWorkspaceLibrary()
  return {
    vim.env.VIMRUNTIME,
    '${3rd}/luv/library',
  }
end

function M.defaultConfig()
  return {
    runtime = {
      path = {
        '?.lua',
        '?/init.lua',
      },
      version = 'LuaJIT',
      pathStrict = true,
    },
    workspace = {
      ignoreDir = {'lua'},
      checkThirdParty = false,
      library = defaultWorkspaceLibrary(),
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
      globals = {'vim', 'dump'},
      unusedLocalExclude = {'_*'},
      neededFileStatus = {
        ['codestyle-check'] = 'Any',
      },
    },
    completion = {
      postfix = '.',
      showWord = 'Disable',
      callSnippet = 'Replace',
      keywordSnippet = 'Replace',
    },
  }
end

--- @param client lsp.Client
--- @return boolean
function M.onInit(client)
  local path = client.workspace_folders[1].name

  if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
    return true
  end

  vim.notify('.luarc.json(c) not found. Loading defaults.')
  client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
    Lua = M.defaultConfig()
  })

  client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})

  return true
end

---@return lsp.ClientConfig
function M.clientConfig(file)
  return {
    name = 'luals',
    filetype = 'lua',
    cmd = {
      'lua-language-server',
      -- '--loglevel=trace',
    },
    -- trace = 'verbose',
    root_dir = vim.fs.dirname(vim.fs.find({
      '.luarc.jsonc',
      '.luarc.json',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      '.git',
    }, {path = file, upward = true})[1]),
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
    on_init = M.onInit,
  }
end

return M
