local handlers = require 'arctgx.lsp.handlers'
local lsp = require('vim.lsp')
local util = require 'vim.lsp.util'

local Buf = {}

local function request(method, params, handler)
  return vim.lsp.buf_request(0, method, params, handler)
end

local function previewLocation(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    vim.notify(ctx.method .. ': no location found.')
    return nil
  end
  if vim.tbl_islist(result) then
    print(vim.inspect('islist'))
    lsp.util.preview_location(result[1])
    return
  end
  lsp.util.preview_location(result)
end

function Buf.workspaceFolders()
  dump(lsp.buf.list_workspace_folders())
end

function Buf.peekDefinition()
  local params = lsp.util.make_position_params()
  request('textDocument/definition', params, previewLocation)
end

return Buf
