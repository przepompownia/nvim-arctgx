local M = {}
local lsp = vim.lsp

local ns = vim.api.nvim_create_namespace('arctgxLsp')

function M.ns()
  return ns
end

function M.defaultClientCapabilities()
  local capabilities = lsp.protocol.make_client_capabilities()
  if capabilities.workspace.didChangeWatchedFiles then
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  end
  local cmpNvimLspOk, cmpNvimLsp = pcall(require, 'cmp_nvim_lsp')
  if cmpNvimLspOk then
    capabilities = vim.tbl_deep_extend('force', capabilities, cmpNvimLsp.default_capabilities(capabilities))
  end
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return capabilities
end

---@param file string
---@param rootPatterns string[]
function M.findRoot(file, rootPatterns)
  return vim.fs.dirname(vim.fs.find(rootPatterns, {
    path = file,
    upward = true,
    stop = vim.uv.os_homedir(),
  })[1] or file)
end

return M
