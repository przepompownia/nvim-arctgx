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
      showWord = 'Disable',
      callSnippet = 'Replace',
      keywordSnippet = 'Replace',
    },
  }
end

--- @param client vim.lsp.Client
--- @return boolean
function M.onInit(client)
  local path = client.workspace_folders[1].name

  if vim.uv.fs_stat(path .. '/.luarc.jsonc') or vim.uv.fs_stat(path .. '/.luarc.json') then
    return true
  end

  vim.notify('.luarc.json(c) not found. Loading defaults.', vim.log.levels.INFO, {title = 'LSP'})
  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, M.defaultConfig())

  client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})

  return true
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
    capabilities = lsp.defaultClientCapabilities(),
    on_attach = function (_, bufnr)
      local root = lsp.findRoot(vim.api.nvim_buf_get_name(bufnr), rootPatterns)
      if not vim.tbl_contains(vim.lsp.buf.list_workspace_folders(), root) then
        vim.notify(('"%s" added to workspace folders'):format(root), vim.log.levels.INFO, {title = 'LSP'})
        vim.lsp.buf.add_workspace_folder(root)
      end
    end,
    settings = {
      Lua = {}
    }
  }
end

return M
