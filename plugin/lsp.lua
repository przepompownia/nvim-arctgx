local lsp = vim.lsp
local buf = require('arctgx.lsp.buf')

vim.lsp.set_log_level(vim.log.levels.WARN)
local hlMap = {
  LspReferenceRead = 'IdeReferenceRead',
  LspReferenceText = 'IdeReferenceText',
  LspReferenceWrite = 'IdeReferenceWrite'
}
for key, value in pairs(hlMap) do
  vim.api.nvim_set_hl(require('arctgx.lsp').ns(), key, {link = value})
end
vim.api.nvim_set_hl_ns(require('arctgx.lsp').ns())

local border = 'rounded'
local origUtilOpenFloatingPreview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return origUtilOpenFloatingPreview(contents, syntax, opts, ...)
end

vim.keymap.set('n', '<Plug>(ide-diagnostic-info)', vim.diagnostic.open_float, {})
vim.keymap.set('n', '<Plug>(ide-diagnostic-goto-previous)', vim.diagnostic.goto_prev, {})
vim.keymap.set('n', '<Plug>(ide-diagnostic-goto-next)', vim.diagnostic.goto_next, {})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {})

local augroup = vim.api.nvim_create_augroup('LspDocumentHighlight', {clear = true})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function (ev)
    local opts = {buffer = ev.buf}

    vim.keymap.set('n', '<Plug>(ide-goto-definition)', function ()
      lsp.buf.definition({on_list = require('arctgx.lsp.handlers').onList})
    end, opts)
    vim.keymap.set('n', '<Plug>(ide-goto-definition-in-place)', lsp.buf.definition, opts)
    vim.keymap.set('n', '<Plug>(ide-peek-definition)', function ()
      buf.peekDefinition(ev.buf)
    end, opts)
    vim.keymap.set('n', '<space>D', function ()
      lsp.buf.type_definition({on_list = require('arctgx.lsp.handlers').onList})
    end, opts)
    vim.keymap.set('n', '<Plug>(ide-goto-implementation)', function ()
      lsp.buf.implementation({on_list = require('arctgx.lsp.handlers').onList})
    end, opts)
    vim.keymap.set({'n', 'i'}, '<Plug>(ide-show-signature-help)', lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Plug>(ide-list-workspace-symbols)', lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<Plug>(ide-list-document-symbols)', lsp.buf.document_symbol, opts)
    vim.keymap.set('n', '<Plug>(ide-action-rename)', lsp.buf.rename, opts)
    vim.keymap.set('n', '<Plug>(ide-find-references)', function ()
      lsp.buf.references {includeDeclaration = false}
    end, opts)
    vim.keymap.set('n', '<Plug>(ide-workspace-folder-add)', lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Plug>(ide-workspace-folder-remove)', lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Plug>(ide-workspace-folder-list)', buf.workspaceFolders, opts)
    vim.keymap.set({'v', 'n'}, '<Plug>(ide-code-action)', lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Plug>(ide-toggle-inlay-hints)', function ()
      vim.lsp.inlay_hint.enable(ev.buf, not vim.lsp.inlay_hint.is_enabled(ev.buf))
    end, opts)
    vim.keymap.set({'n', 'v'}, '<Plug>(ide-format-with-all-formatters)', function () return lsp.buf.format({async = true}) end, opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
        group = augroup,
        buffer = ev.buf,
        callback = function (args) vim.lsp.util.buf_clear_references(args.buf) end
      })
      vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = augroup,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight
      })
      vim.api.nvim_create_autocmd({'LspDetach'}, {
        group = augroup,
        buffer = ev.buf,
        callback = function (args)
          vim.lsp.util.buf_clear_references(args.buf)
          for _, cl in ipairs(vim.lsp.get_clients({
            bufnr = args.buf,
          })) do
            if cl.id ~= args.data.client_id and cl.supports_method('textDocument/documentHighlight') then
              return
            end
          end

          vim.api.nvim_clear_autocmds {
            group = augroup,
            buffer = args.buf,
          }
        end,
      })
    end

    -- vim.notify(('Server %s attached to %s'):format(client.name, api.nvim_buf_get_name(ev.buf)))
  end,
})
