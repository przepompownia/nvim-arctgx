local api = vim.api
local lsp = vim.lsp

local keymap = require('arctgx.vim.abstractKeymap')

lsp.set_log_level(vim.log.levels.WARN)
local hlMap = {
  LspReferenceRead = 'IdeReferenceRead',
  LspReferenceText = 'IdeReferenceText',
  LspReferenceWrite = 'IdeReferenceWrite'
}
for key, value in pairs(hlMap) do
  api.nvim_set_hl(require('arctgx.lsp').ns(), key, {link = value})
end
api.nvim_set_hl_ns(require('arctgx.lsp').ns())

local border = 'rounded'
local origUtilOpenFloatingPreview = lsp.util.open_floating_preview
--- @diagnostic disable-next-line: duplicate-set-field
function lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return origUtilOpenFloatingPreview(contents, syntax, opts, ...)
end

lsp.handlers[lsp.protocol.Methods.textDocument_references] = lsp.with(
  lsp.handlers[lsp.protocol.Methods.textDocument_references],
  {
    on_list = function (params)
      local client = assert(lsp.get_client_by_id(params.context.client_id))
      if #params.items == 1 then
        lsp.util.jump_to_location(params.items[1].user_data, client.offset_encoding, true)
        return
      end
      vim.fn.setqflist({}, ' ', {title = 'References', items = params.items, context = params.context})
      api.nvim_command('botright copen')
    end,
  }
)

local augroup = api.nvim_create_augroup('LspDocumentHighlight', {clear = true})
api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('UserLspConfig', {}),
  callback = function (ev)
    local opts = {buffer = ev.buf}

    keymap.set('n', 'langGoToDefinition', lsp.buf.definition, opts)
    keymap.set('n', 'langGoToDefinitionInPlace', lsp.buf.definition, opts)
    keymap.set('n', 'langGoToTypeDefinition', lsp.buf.type_definition, opts)
    keymap.set('n', 'langGoToImplementation', lsp.buf.implementation, opts)
    keymap.set('n', 'langFindWorkspaceSymbols', lsp.buf.workspace_symbol, opts)
    keymap.set('n', 'langShowSignatureHelp', lsp.buf.signature_help, opts)
    keymap.set('n', 'langFindDocumentSymbols', lsp.buf.document_symbol, opts)
    keymap.set('n', 'langFindReferences', function ()
      lsp.buf.references {includeDeclaration = false}
    end, opts)
    keymap.set('n', 'langWorkspaceFolderAdd', lsp.buf.add_workspace_folder, opts)
    keymap.set('n', 'langWorkspaceFolderRemove', lsp.buf.remove_workspace_folder, opts)
    keymap.set('n', 'langWorkspaceFolderList', function ()
      dump(lsp.buf.list_workspace_folders())
    end, opts)
    keymap.set('n', 'langToggleInlayHints', function ()
      lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({bufnr = ev.buf}), {bufnr = ev.buf})
    end, opts)
    keymap.set({'n', 'v'}, 'langApplyAllformatters', function () return lsp.buf.format({async = true}) end, opts)

    local client = lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.documentHighlightProvider then
      api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
        group = augroup,
        buffer = ev.buf,
        callback = function (args) lsp.util.buf_clear_references(args.buf) end
      })
      api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = augroup,
        buffer = ev.buf,
        callback = lsp.buf.document_highlight
      })
      api.nvim_create_autocmd({'LspDetach'}, {
        group = augroup,
        buffer = ev.buf,
        callback = function (args)
          lsp.util.buf_clear_references(args.buf)
          local existsOtherClientWithHl = vim.iter(lsp.get_clients({
            bufnr = args.buf,
            method = lsp.protocol.Methods.textDocument_documentHighlight,
          })):any(function (cl)
            return cl.id ~= args.data.client_id
          end)
          if existsOtherClientWithHl then
            return
          end

          api.nvim_clear_autocmds {
            group = augroup,
            buffer = args.buf,
          }
        end,
      })
    end
  end,
})

api.nvim_create_autocmd('FileType', {
  pattern = {'lua'},
  group = api.nvim_create_augroup('arctgx.lsp.clients.luals', {}),
  callback = function (args)
    lsp.start(
      require('arctgx.lsp.serverConfigs.luaLs').clientConfig(args.file),
      {
        bufnr = args.buf,
        reuse_client = function (client, config)
          return client.name == config.name
        end
      })
  end,
})

local function willRenameFilesHandler(response)
  for clientId, clientResponse in pairs(response) do
    local client = lsp.get_client_by_id(clientId)
    if nil == client then
      vim.notify(('Client %s does not exist'):format(clientId), vim.log.levels.ERROR, {title = 'LSP: workspace/willRenameFiles'})

      return
    end

    lsp.util.apply_workspace_edit(clientResponse.result, client.offset_encoding)
    -- dump(clientResponse.result)
  end
end

local function willRenameCurrentBuffer(newPath)
  if not vim.startswith(newPath, '/') then
    newPath = vim.fs.joinpath(vim.uv.cwd(), newPath)
  end
  lsp.buf_request_all(
    0,
    lsp.protocol.Methods.workspace_willRenameFiles,
    {
      files = {{oldUri = vim.uri_from_bufnr(0), newUri = vim.uri_from_fname(newPath)}},
    },
    willRenameFilesHandler
  )
end
api.nvim_create_user_command('WillRenameCurrentBuffer', function (opts)
  if 0 ~= #opts.args then
    willRenameCurrentBuffer(opts.args)
    return
  end

  vim.ui.input({
    completion = 'file',
    default = api.nvim_buf_get_name(0),
    prompt = 'New path: ',
  }, function (input)
    if not input then
      return
    end
    willRenameCurrentBuffer(input)
  end)
end, {nargs = '*', complete = 'file'})
