local M = {}

local ns = vim.api.nvim_create_namespace('arctgxLsp')

function M.ns()
  return ns
end

--- @type lsp.ClientCapabilities?
local capabilities = nil

--- @param additionalCapabilities lsp.ClientCapabilities
function M.extendClientCapabilities(additionalCapabilities)
  capabilities = vim.tbl_deep_extend('force', capabilities, additionalCapabilities)
end

function M.defaultClientCapabilities()
  if capabilities then
    return capabilities
  end

  capabilities = vim.lsp.protocol.make_client_capabilities()

  if capabilities.workspace.didChangeWatchedFiles then
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  end

  return capabilities
end

--- @param file string?
--- @param rootPatterns string[]?
function M.findRoot(file, rootPatterns)
  file = vim.fn.fnamemodify(file or '', ':p')
  return vim.fs.dirname(vim.fs.find(rootPatterns or {}, {
    path = file,
    upward = true,
    stop = vim.uv.os_homedir(),
  })[1] or file)
end

function M.findRootOfWorkingClient(file, clientName)
  file = vim.fn.fnamemodify(file or '', ':p')
  local result = nil
  for _, client in ipairs(vim.lsp.get_clients({name = clientName})) do
    local rootDir = vim.fn.fnamemodify(client.root_dir, ':p')
    if vim.startswith(file, rootDir) and #rootDir > #(result or {}) then
      result = rootDir
    end
  end

  return result
end

return M
