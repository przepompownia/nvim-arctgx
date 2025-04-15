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
      globals = {'vim', 'dump', 'verboseLog', 'vlog'},
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

return M
