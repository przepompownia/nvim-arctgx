local api = vim.api

local M = {}

local ns = vim.api.nvim_create_namespace('arctgxLsp')

function M.ns()
  return ns
end

local clientNamesPerBuffer = {}
local status = {}

function M.getStatus(buf)
  return status[buf or api.nvim_get_current_buf()] or ''
end

function M.updateAttachedClientNames(buf, clientId, clientName)
  if not clientNamesPerBuffer[buf] then
    clientNamesPerBuffer[buf] = {}
  end
  clientNamesPerBuffer[buf][clientId] = clientName
  status[buf] = table.concat(vim.tbl_values(clientNamesPerBuffer[buf]), ',')
end

--- @type lsp.ClientCapabilities?
local clientCapabilities = nil

local origMakeClientCap = vim.lsp.protocol.make_client_capabilities

--- @param additionalCapabilities lsp.ClientCapabilities
function M.extendClientCapabilities(additionalCapabilities)
  clientCapabilities = vim.tbl_deep_extend('force', clientCapabilities, additionalCapabilities)
end

function M.overrideClientCapabilities()
  vim.lsp.protocol.make_client_capabilities = function ()
    if clientCapabilities then
      return clientCapabilities
    end

    clientCapabilities = origMakeClientCap()

    if clientCapabilities.workspace.didChangeWatchedFiles then
      clientCapabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    end

    return clientCapabilities
  end
end

function M.shouldAttach(buf)
  if api.nvim_buf_get_name(buf):match([[^(diffview://)]]) then
    return false
  end
  return true
end

function M.rootDir(buf, onDir, root)
  if not M.shouldAttach(buf) then
    return
  end
  onDir(root)
end

return M
