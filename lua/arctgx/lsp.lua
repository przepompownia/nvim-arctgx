local M = {}
local api = vim.api
local lsp = require('vim.lsp')
local diagnostic = require('vim.diagnostic')
local keymap = require('vim.keymap')
local buf = require('arctgx.lsp.buf')

local augroup = api.nvim_create_augroup('LspDocumentHighlight', {clear = true})

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
  bufMap('n', '<Plug>(ide-workspace-folder-add)', lsp.buf.add_workspace_folder)
  bufMap('n', '<Plug>(ide-workspace-folder-remove)', lsp.buf.remove_workspace_folder)
  bufMap('n', '<Plug>(ide-workspace-folder-list)', buf.workspaceFolders)
  bufMap({'v', 'n'}, '<Plug>(ide-code-action)', lsp.buf.code_action)
  bufMap('n', '<Plug>(ide-diagnostic-goto-previous)', diagnostic.goto_prev)
  bufMap('n', '<Plug>(ide-diagnostic-goto-next)', diagnostic.goto_next)
  bufMap('n', '<space>q', diagnostic.setloclist)
  bufMap({'n', 'v'}, '<Plug>(ide-format-with-all-formatters)', function() return lsp.buf.format({async = true}) end)

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
      group = augroup,
      buffer = bufnr,
      callback = function (args)
        vim.lsp.buf.clear_references()
        local supported = false
        vim.lsp.for_each_buffer_client(args.buf, function (client, client_id)
          if (client_id ~= args.data.client_id) and client.supports_method('textDocument/documentHighlight') then
            supported = true
          end
        end)

        if supported then
          return
        end

        api.nvim_clear_autocmds {
          group = augroup,
          buffer = args.buf,
        }
      end,
    })
  end

  -- vim.notify(('Server %s attached to %s'):format(client.name, api.nvim_buf_get_name(bufnr)))
end

return M
