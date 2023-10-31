local base = require('arctgx.base')

local vim = vim
local api = vim.api
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'

local Handlers = {}

---@param params {items: table, title: string, offset_encoding: string}
function Handlers.onList(params)
  params.offset_encoding = params.offset_encoding or 'utf-16'
  local items = util.locations_to_items(params.items, params.offset_encoding)
  if #items == 1 then
    local item = items[1]
    base.tabDrop(item.filename, item.lnum, item.col)
    vim.cmd 'normal zt'

    return
  end

  vim.fn.setqflist({}, ' ', {
    title = params.title,
    items = params.items,
  })
  api.nvim_command('copen')
end

function Handlers.tabDropLocationHandler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')

    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  if not vim.tbl_islist(result) then
    result = {result}
  end

  Handlers.onList({
    title = 'LSP locations',
    items = result,
    offset_encoding = client.offset_encoding,
  })
end

return Handlers
