local M = {}
local api = vim.api
local lsp = require('vim.lsp')
local diagnostic = require('vim.diagnostic')
local keymap = require('vim.keymap')

local printWorkspaceFolders = function()
  print(vim.inspect(lsp.buf.list_workspace_folders()))
end

local function previewLocation(_, result, _, _)
  if result == nil or vim.tbl_isempty(result) then
    lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    print(vim.inspect('islist'))
    lsp.util.preview_location(result[1])
    return
  end
  lsp.util.preview_location(result)
end

local function peekDefinition()
  local params = lsp.util.make_position_params()
  return lsp.buf_request(0, 'textDocument/definition', params, previewLocation)
end
api.nvim_create_augroup ('LspDocumentHighlight', { clear = true })

function M.onAttach(client, bufnr)
  local function bufMap(modes, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = opts.noremap or true
    opts.silent = opts.silent or true
    keymap.set(modes, lhs, rhs, opts)
  end

  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  bufMap('n', '<Plug>(ide-goto-definition)', lsp.buf.definition)
  bufMap('n', '<Plug>(ide-peek-definition)', peekDefinition)
  bufMap('n', '<Plug>(ide-hover)', lsp.buf.hover)
  bufMap('n', '<Plug>(ide-goto-implementation)', lsp.buf.implementation)
  bufMap({ 'n', 'i' }, '<Plug>(ide-show-signature-help)', lsp.buf.signature_help)
  bufMap('n', '<Plug>(ide-list-workspace-symbols)', lsp.buf.workspace_symbol)
  bufMap('n', '<Plug>(ide-list-document-symbols)', lsp.buf.document_symbol)
  bufMap('n', '<Plug>(ide-action-rename)', lsp.buf.rename)
  bufMap('n', '<Plug>(ide-find-references)', function()
    lsp.buf.references { includeDeclaration = false }
  end)
  bufMap('n', '<Plug>(ide-diagnostic-info)', diagnostic.open_float)
  bufMap('n', '<space>wa', lsp.buf.add_workspace_folder)
  bufMap('n', '<space>wr', lsp.buf.remove_workspace_folder)
  bufMap('n', '<space>wl', printWorkspaceFolders)
  bufMap('n', '<space>D', lsp.buf.type_definition)
  bufMap('n', '<space>ca', lsp.buf.code_action)
  bufMap('n', '[d', diagnostic.goto_prev)
  bufMap('n', ']d', diagnostic.goto_next)
  bufMap('n', '<space>q', diagnostic.setloclist)
  bufMap('n', '<space>f', lsp.buf.formatting)
  if client.resolved_capabilities.document_range_formatting then
    bufMap('v', '<space>f', lsp.buf.range_formatting)
  end

  if client.resolved_capabilities.document_highlight then
    api.nvim_create_autocmd ({'CursorHold', 'CursorHoldI'}, {
      group = 'LspDocumentHighlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    api.nvim_create_autocmd ({'CursorMoved', 'CursorMovedI'}, {
      group = 'LspDocumentHighlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
    api.nvim_exec([[
      hi link LspReferenceRead IdeReferenceRead
      hi link LspReferenceText IdeReferenceText
      hi link LspReferenceWrite IdeReferenceWrite
    ]], false)
  end

  -- vim.notify(('Server %s attached to %s'):format(client.name, api.nvim_buf_get_name(bufnr)))
end

return M
