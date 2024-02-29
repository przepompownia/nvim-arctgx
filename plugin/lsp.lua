local lsp = vim.lsp
local keymap = require('arctgx.vim.abstractKeymap')

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

vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_references] = vim.lsp.with(
  vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_references],
  {
    on_list = function (params)
      local client = assert(vim.lsp.get_client_by_id(params.context.client_id))
      if #params.items == 1 then
        vim.lsp.util.jump_to_location(params.items[1].user_data, client.offset_encoding, true)
        return
      end
      vim.fn.setqflist({}, ' ', {title = 'References', items = params.items, context = params.context})
      vim.api.nvim_command('botright copen')
    end,
  }
)

local augroup = vim.api.nvim_create_augroup('LspDocumentHighlight', {clear = true})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function (ev)
    local opts = {buffer = ev.buf}

    keymap.set('n', 'langGoToDefinition', lsp.buf.definition, opts)
    keymap.set('n', 'langGoToDefinitionInPlace', lsp.buf.definition, opts)
    keymap.set('n', 'langGoToTypeDefinition', lsp.buf.type_definition, opts)
    keymap.set('n', 'langGoToImplementation', lsp.buf.implementation, opts)
    keymap.set({'n', 'i'}, 'langShowSignatureHelp', lsp.buf.signature_help, opts)
    keymap.set('n', 'langFindWorkspaceSymbols', lsp.buf.workspace_symbol, opts)
    keymap.set('n', 'langFindDocumentSymbols', lsp.buf.document_symbol, opts)
    keymap.set('n', 'langRenameSymbol', lsp.buf.rename, opts)
    keymap.set('n', 'langFindReferences', function ()
      lsp.buf.references {includeDeclaration = false}
    end, opts)
    keymap.set('n', 'langWorkspaceFolderAdd', lsp.buf.add_workspace_folder, opts)
    keymap.set('n', 'langWorkspaceFolderRemove', lsp.buf.remove_workspace_folder, opts)
    keymap.set('n', 'langWorkspaceFolderList', function ()
      dump(vim.lsp.buf.list_workspace_folders())
    end, opts)
    -- keymap.set({'v', 'n'}, 'langCodeAction', lsp.buf.code_action, opts)
    keymap.set('n', 'langToggleInlayHints', function ()
      vim.lsp.inlay_hint.enable(ev.buf, not vim.lsp.inlay_hint.is_enabled(ev.buf))
    end, opts)
    keymap.set({'n', 'v'}, 'langApplyAllformatters', function () return lsp.buf.format({async = true}) end, opts)

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
          local existsOtherClientWithHl = vim.iter(vim.lsp.get_clients({
            bufnr = args.buf,
            method = vim.lsp.protocol.Methods.textDocument_documentHighlight,
          })):any(function (cl)
            return cl.id ~= args.data.client_id
          end)
          if existsOtherClientWithHl then
            return
          end

          vim.api.nvim_clear_autocmds {
            group = augroup,
            buffer = args.buf,
          }
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'lua'},
  group = vim.api.nvim_create_augroup('arctgx.lsp.clients.luals', {}),
  callback = function (args)
    vim.lsp.start(
      require('arctgx.lsp.serverConfigs.luaLs').clientConfig(args.file),
      {
        bufnr = args.buf,
        reuse_client = function (client, config)
          return client.name == config.name
        end
      })
  end,
})
