local base = require('arctgx.base')

local vim = vim
local api = vim.api
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'

local function get_line_byte_from_position(bufnr, position)
  -- LSP's line and characters are 0-indexed
  -- Vim's line and columns are 1-indexed
  local col = position.character
  -- When on the first character, we can ignore the difference between byte and
  -- character
  if col > 0 then
    local line = position.line
    local lines = api.nvim_buf_get_lines(bufnr, line, line + 1, false)
    if #lines > 0 then
      return vim.str_byteindex(lines[1], col)
    end
  end
  return col
end

-- based on lsp/util.lua
local tab_drop_location = function(location)
  -- location may be Location or LocationLink
  local uri = location.uri or location.targetUri
  if uri == nil then return end
  -- Save position in jumplist
  vim.cmd "normal! m'"

  -- Push a new item into tagstack
  -- local from = {vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0}
  -- local items = {{tagname=vim.fn.expand('<cword>'), from=from}}
  -- vim.fn.settagstack(vim.fn.win_getid(), {items=items}, 't')

  --- Jump to new location (adjusting for UTF-16 encoding of characters)
  local range = location.range or location.targetSelectionRange
  local row = range.start.line
  local bufnr = vim.uri_to_bufnr(uri)
  local path = vim.api.nvim_buf_get_name(bufnr)

  local col = get_line_byte_from_position(bufnr, range.start)
  base.tab_drop(path, row + 1, col + 1)

  vim.cmd 'normal zt'

  return true
end

local function location_handler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')

    return nil
  end

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if not vim.tbl_islist(result) then
    tab_drop_location(result)

    return
  end

  if #result == 1 then
    tab_drop_location(result[1])

    return
  end

  vim.fn.setqflist({}, ' ', {title = 'LSP locations', items = util.locations_to_items(result)})
  api.nvim_command('copen')
end

vim.lsp.handlers['textDocument/declaration'] = location_handler
vim.lsp.handlers['textDocument/definition'] = location_handler
vim.lsp.handlers['textDocument/typeDefinition'] = location_handler
vim.lsp.handlers['textDocument/implementation'] = location_handler
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = false,
  }
)
-- vim.lsp.set_log_level('debug')

vim.fn.sign_define('DiagnosticSignHint', {text='💡', texthl='IdeHintSign', linehl='', numhl='IdeLineNrHint'})
vim.fn.sign_define('DiagnosticSignInfo', {text='', texthl='IdeInfoSign', linehl='', numhl='IdeLineNrInfo'})
vim.fn.sign_define('DiagnosticSignWarn', {text='⚠', texthl='IdeWarningSign', linehl='', numhl='IdeLineNrWarning'})
vim.fn.sign_define('DiagnosticSignError', {text='', texthl='IdeErrorSign', linehl='', numhl='IdeLineNrError'})
