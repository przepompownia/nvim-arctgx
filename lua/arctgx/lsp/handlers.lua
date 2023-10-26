local base = require('arctgx.base')

local vim = vim
local api = vim.api
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'

local Handlers = {}

-- based on lsp/util.lua
local tabDropLocation = function(location, offset_encoding)
  -- location may be Location or LocationLink
  local uri = location.uri or location.targetUri
  if uri == nil then return end
  if offset_encoding == nil then
    vim.notify_once('tabDropLocation must be called with valid offset encoding', vim.log.levels.WARN)
  end

  local range = location.range or location.targetSelectionRange
  local row = range.start.line
  local bufnr = vim.uri_to_bufnr(uri)
  local path = vim.api.nvim_buf_get_name(bufnr)

  local col = util._get_line_byte_from_position(bufnr, range.start, offset_encoding)
  base.tabDrop(path, row + 1, col + 1)

  vim.cmd 'normal zt'

  return true
end

function Handlers.tabDropLocationHandler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')

    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if not vim.tbl_islist(result) then
    tabDropLocation(result, client.offset_encoding)

    return
  end

  if #result == 1 then
    tabDropLocation(result[1], client.offset_encoding)

    return
  end

  vim.fn.setqflist({}, ' ', {
    title = 'LSP locations',
    items = util.locations_to_items(result, client.offset_encoding),
  })
  api.nvim_command('copen')
end

return Handlers
