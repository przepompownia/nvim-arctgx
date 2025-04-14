local api = vim.api

local extension = {}

local function newClassFromCodeAction(path)
  api.nvim_create_autocmd('LspNotify', {
    once = true,
    pattern = path,
    callback = function (args)
      local request = args.data
      local client = assert(vim.lsp.get_clients({id = request.client_id})[1])
      if client.name ~= 'phpactor'
        or request.method ~= vim.lsp.protocol.Methods.textDocument_didOpen
        or request.params.textDocument.uri ~= vim.uri_from_bufnr(args.buf)
      then
        return
      end
      vim.lsp.buf.code_action({
        apply = true,
        filter = function (action)
          return action.kind == 'quickfix.create_class'
        end
      })
    end
  })
  vim.cmd.edit({args = {path}})
end

function extension.classNew()
  local bufname = api.nvim_buf_get_name(0)
  vim.ui.input({
    prompt = 'File: ',
    completion = 'file',
    default = bufname == '' and vim.uv.cwd() or bufname,
  }, newClassFromCodeAction)
end

function extension.dumpConfig()
  vim.lsp.buf_request_all(0, 'phpactor/debug/config', {['return'] = true}, function (result)
    for _, data in pairs(result) do
      require('arctgx.base').displayInWindow('Phpactor LSP Configuration', 'json', data.result)
    end
  end)
end

function extension.status()
  vim.lsp.buf_request_all(0, 'phpactor/status', {['return'] = true}, function (result)
    for _, data in pairs(result) do
      require('arctgx.base').displayInWindow('Phpactor Status', 'markdown', data.result)
    end
  end)
end

function extension.reindex()
  vim.lsp.buf_notify(0, 'phpactor/indexer/reindex', {})
end

api.nvim_create_user_command('PhpactorLSPDumpConfig', extension.dumpConfig, {nargs = 0})
api.nvim_create_user_command('PhpactorLSPServerStatus', extension.status, {nargs = 0})
api.nvim_create_user_command('PhpactorLSPServerReindex', extension.reindex, {nargs = 0})

return extension
