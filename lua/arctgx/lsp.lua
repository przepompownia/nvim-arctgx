local M = {}
local api = vim.api
local lsp = require('vim.lsp')
local diagnostic = require('vim.diagnostic')
local keymap = require('vim.keymap')
local buf = require('arctgx.lsp.buf')

api.nvim_create_augroup('LspDocumentHighlight', {clear = true})

function M.onAttach(client, bufnr)
  local function bufMap(modes, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = opts.noremap or true
    opts.silent = opts.silent or true
    keymap.set(modes, lhs, rhs, opts)
  end

  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  bufMap('n', '<Plug>(ide-goto-definition)', buf.definition)
  bufMap('n', '<Plug>(ide-goto-definition-in-place)', buf.definitionInPlace)
  bufMap('n', '<Plug>(ide-peek-definition)', buf.peekDefinition)
  bufMap('n', '<space>D', buf.typeDefinition)
  bufMap('n', '<Plug>(ide-hover)', lsp.buf.hover)
  bufMap('n', '<Plug>(ide-goto-implementation)', buf.implementation)
  bufMap({'n', 'i'}, '<Plug>(ide-show-signature-help)', lsp.buf.signature_help)
  bufMap('n', '<Plug>(ide-list-workspace-symbols)', lsp.buf.workspace_symbol)
  bufMap('n', '<Plug>(ide-list-document-symbols)', lsp.buf.document_symbol)
  bufMap('n', '<Plug>(ide-action-rename)', lsp.buf.rename)
  bufMap('n', '<Plug>(ide-find-references)',
    function() lsp.buf.references {includeDeclaration = false} end)
  bufMap('n', '<Plug>(ide-diagnostic-info)',
    function() diagnostic.open_float({border = 'rounded'}) end)
  bufMap('n', '<space>wa', lsp.buf.add_workspace_folder)
  bufMap('n', '<space>wr', lsp.buf.remove_workspace_folder)
  bufMap('n', '<space>wl', buf.workspaceFolders)
  bufMap('n', '<space>ca', lsp.buf.code_action)
  bufMap('n', '[d', diagnostic.goto_prev)
  bufMap('n', ']d', diagnostic.goto_next)
  bufMap('n', '<space>q', diagnostic.setloclist)
  bufMap('n', '<space>f', function() return lsp.buf.format({async = true}) end)
  if client.server_capabilities.documentRangeFormattingProvider then
    bufMap('v', '<space>f', lsp.buf.range_formatting)
  end

  if client.server_capabilities.documentHighlightProvider then
    api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
      group = 'LspDocumentHighlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references
    })
    api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
      group = 'LspDocumentHighlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight
    })
    local hlMap = {
      LspReferenceRead = 'IdeReferenceRead',
      LspReferenceText = 'IdeReferenceText',
      LspReferenceWrite = 'IdeReferenceWrite'
    }
    for key, value in pairs(hlMap) do
      api.nvim_set_hl(0, key, {link = value})
    end
    api.nvim_create_autocmd({'LspDetach'}, {
      group = 'LspDocumentHighlight',
      buffer = bufnr,
      callback = function (args)
        vim.lsp.buf.clear_references()
        local supported = false
        vim.lsp.for_each_buffer_client(args.buf, function (client, client_id)
          if (client_id ~= args.client_id) and client.supports_method('textDocument/documentHighlight') then
            supported = true
          end
        end)

        if supported then
          return
        end

        api.nvim_clear_autocmds {
          group = 'LspDocumentHighlight',
          buffer = args.buf,
        }
      end,
    })
  end

  -- vim.notify(('Server %s attached to %s'):format(client.name, api.nvim_buf_get_name(bufnr)))
end

return M
