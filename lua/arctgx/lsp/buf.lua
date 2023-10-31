local Buf = {}

local function request(method, params, handler, bufnr)
  return vim.lsp.buf_request_all(bufnr, method, params, handler)(0, method, params, handler)
end

local function previewLocation(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    vim.notify(ctx.method .. ': no location found.')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
    return
  end
  vim.lsp.util.preview_location(result)
end

function Buf.workspaceFolders()
  dump(vim.lsp.buf.list_workspace_folders())
end

function Buf.peekDefinition(bufnr)
  local params = vim.lsp.util.make_position_params()
  request('textDocument/definition', params, previewLocation, bufnr)
end

return Buf
