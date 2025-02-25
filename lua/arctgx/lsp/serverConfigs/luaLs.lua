local M = {}

local function defaultWorkspaceLibrary(rootDir)
  return {
    vim.env.VIMRUNTIME .. '/lua',
    '${3rd}/luv/library/lua',
    rootDir and (rootDir .. '/lua'),
  }
end

function M.defaultConfig(rootDir)
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
      library = defaultWorkspaceLibrary(rootDir),
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
      globals = {'vim', 'dump', 'verboseLog'},
      unusedLocalExclude = {'_*'},
      neededFileStatus = {
        ['codestyle-check'] = 'Any',
      },
    },
    completion = {
      showWord = 'Disable',
      callSnippet = 'Replace',
      keywordSnippet = 'Replace',
    },
  }
end

--- @param client vim.lsp.Client
--- @return boolean
function M.onInit(client)
  local triggerCharaters = {'\t', '\n', '.', ':', "'", '"', ',', '#', '*', '@', '|', '=', '-', ' ', '+', '?'}
  client.server_capabilities.completionProvider.triggerCharacters = triggerCharaters

  local path = client.workspace_folders[1].name

  if vim.uv.fs_stat(path .. '/.luarc.jsonc') or vim.uv.fs_stat(path .. '/.luarc.json') then
    return true
  end

  vim.notify('.luarc.json(c) not found. Loading defaults.', vim.log.levels.INFO)
  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, M.defaultConfig(path))

  return client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, {settings = client.config.settings})
end

local rootPatterns = {
  '.luarc.jsonc',
  '.luarc.json',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  '.git',
}

--- @return vim.lsp.ClientConfig
function M.clientConfig(file)
  local lsp = require('arctgx.lsp')
  return {
    name = 'luals',
    cmd = {
      'lua-language-server',
      -- '--loglevel=trace',
    },
    -- trace = 'verbose',
    root_dir = lsp.findRoot(file:gsub(
      '^' .. vim.fn.stdpath('config'),
      vim.env.NVIM_UNSANDBOXED_CONFIGDIR or vim.fn.stdpath('config'),
      1
    ), rootPatterns),
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
    on_init = M.onInit,
    on_attach = function (_, bufnr)
      local root = lsp.findRoot(vim.api.nvim_buf_get_name(bufnr), rootPatterns)
      if not vim.tbl_contains(vim.lsp.buf.list_workspace_folders(), root) then
        vim.notify(('"%s" added to workspace folders'):format(root), vim.log.levels.INFO)
        vim.lsp.buf.add_workspace_folder(root)
      end
    end,
    settings = {
      Lua = {}
    }
  }
end

return M
