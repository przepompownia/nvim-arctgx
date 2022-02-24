local M = {}
local api = vim.api
local lsp = require('vim.lsp')
local diagnostic = require('vim.diagnostic')
local keymap = require('vim.keymap')

local printWorkspaceFolders = function ()
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

function M.onAttach(client, bufnr)
  local function buf_map(modes, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = opts.noremap or true
    opts.silent = opts.silent or true
    keymap.set(modes, lhs, rhs, opts)
  end

  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  buf_map('n', '<Plug>(ide-goto-definition)', lsp.buf.definition)
  buf_map('n', '<Plug>(ide-peek-definition)', peekDefinition)
  buf_map('n', '<Plug>(ide-hover)', lsp.buf.hover)
  buf_map('n', '<Plug>(ide-goto-implementation)', lsp.buf.implementation)
  buf_map({'n', 'i'}, '<Plug>(ide-show-signature-help)', lsp.buf.signature_help)
  buf_map('n', '<Plug>(ide-list-workspace-symbols)', lsp.buf.workspace_symbol)
  buf_map('n', '<Plug>(ide-list-document-symbols)', lsp.buf.document_symbol)
  buf_map('n', '<Plug>(ide-action-rename)', lsp.buf.rename)
  buf_map('n', '<Plug>(ide-find-references)', function ()
    lsp.buf.references {includeDeclaration = false}
  end)
  buf_map('n', '<Plug>(ide-diagnostic-info)', diagnostic.open_float)
  buf_map('n', '<space>wa', lsp.buf.add_workspace_folder)
  buf_map('n', '<space>wr', lsp.buf.remove_workspace_folder)
  buf_map('n', '<space>wl', printWorkspaceFolders)
  buf_map('n', '<space>D', lsp.buf.type_definition)
  buf_map('n', '<space>ca', lsp.buf.code_action)
  buf_map('n', '[d', diagnostic.goto_prev)
  buf_map('n', ']d', diagnostic.goto_next)
  buf_map('n', '<space>q', diagnostic.setloclist)
  buf_map('n', '<space>f', lsp.buf.formatting)
  if client.resolved_capabilities.document_range_formatting then
    buf_map('v', '<space>f', lsp.buf.range_formatting)
  end

  if client.resolved_capabilities.document_highlight then
    api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#E6F4AA
      hi LspReferenceText cterm=bold ctermbg=red guibg=#F4EDAA
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#F4DBAA
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  -- vim.notify(('Server %s attached to %s'):format(client.name, api.nvim_buf_get_name(bufnr)))
end

return M
