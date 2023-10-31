local base = require('arctgx.base')

local vim = vim
local api = vim.api
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'

local Handlers = {}

---@param params {items: table, title: string}
function Handlers.onList(params)
  if #params.items == 1 then
    local item = params.items[1]
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
    items = util.locations_to_items(result),
    offset_encoding = client.offset_encoding,
  })
end

return Handlers
