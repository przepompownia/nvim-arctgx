local lsp = vim.lsp

local function willRenameFilesHandler(response)
  for clientId, clientResponse in pairs(response) do
    local client = lsp.get_client_by_id(clientId)
    if nil == client then
      vim.notify(('Client %s does not exist'):format(clientId), vim.log.levels.ERROR, {title = 'LSP: workspace/willRenameFiles'})

      return
    end

    -- lsp.util.apply_workspace_edit(clientResponse.result, client.offset_encoding)
    dump(clientResponse.result)
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
vim.api.nvim_create_user_command('WillRenameCurrentBuffer', function (opts)
  if 0 ~= #opts.args then
    willRenameCurrentBuffer(opts.args)
    return
  end

  vim.ui.input({
    completion = 'file',
    default = vim.api.nvim_buf_get_name(0),
    prompt = 'New path: ',
  }, function (input)
    if not input then
      return
    end
    willRenameCurrentBuffer(input)
  end)
end, {nargs = '*', complete = 'file'})
