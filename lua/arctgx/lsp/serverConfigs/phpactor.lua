local extension = {}

local function newClassFromCodeAction(path)
  vim.api.nvim_create_autocmd('LspNotify', {
    once = true,
    pattern = path,
    callback = function (args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client.name ~= 'phpactor' then
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
  local bufname = vim.api.nvim_buf_get_name(0)
  vim.ui.input({
    prompt = 'File: ',
    completion = 'file',
    default = bufname == '' and vim.uv.cwd() or bufname,
  }, newClassFromCodeAction)
end

local function showWindow(title, filetype, contents)
  local buf = vim.api.nvim_create_buf(false, false)

  vim.bo[buf].filetype = filetype
  vim.bo[buf].bufhidden = 'wipe'
  local lines = vim.split(contents, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = 120,
    height = #lines,
    row = 0.9,
    col = 0.9,
    border = 'rounded',
    style = 'minimal',
    title = title,
    title_pos = 'center',
  })

  vim.wo[win].winblend = 0
end

function extension.dumpConfig()
  vim.lsp.buf_request_all(0, 'phpactor/debug/config', {['return'] = true}, function (result)
    for _, data in pairs(result) do
      showWindow('Phpactor LSP Configuration', 'json', data.result)
    end
  end)
end

function extension.status()
  vim.lsp.buf_request_all(0, 'phpactor/status', {['return'] = true}, function (result)
    for _, data in pairs(result) do
      showWindow('Phpactor Status', 'markdown', data.result)
    end
  end)
end

function extension.reindex()
  vim.lsp.buf_notify(0, 'phpactor/indexer/reindex', {})
end

extension.defaultRootPatterns = {
  'composer.json',
  '.phpactor.json',
  '.git',
}

--- @return vim.lsp.ClientConfig
function extension.clientConfig(file, rootPatterns)
  return {
    name = 'phpactor',
    filetype = 'php',
    cmd_env = {
      XDG_CACHE_HOME = '/tmp'
    },
    cmd = {
      -- 'phpxx',
      vim.uv.fs_realpath(vim.fn.exepath('phpactor')) or 'phpactor',
      'language-server',
      -- '-vvv',
    },
    -- trace = 'verbose',
    root_dir = require('arctgx.lsp').findRoot(file, rootPatterns or extension.defaultRootPatterns),
    log_level = vim.lsp.protocol.MessageType.Warning,
    capabilities = require('arctgx.lsp').defaultClientCapabilities(),
    init_options = {
      ['indexer.enabled_watchers'] = {
        'lsp',
      },
      ['logging.path'] = '/tmp/phpactor.log',
      ['completion_worse.completor.keyword.enabled'] = true,
      ['phpunit.enabled'] = true,
      ['language_server_worse_reflection.inlay_hints.enable'] = true,
      ['language_server_worse_reflection.inlay_hints.types'] = true,
      ['language_server_worse_reflection.inlay_hints.params'] = true,
    },
  }
end

vim.api.nvim_create_user_command('PhpactorLSPDumpConfig', extension.dumpConfig, {nargs = 0})
vim.api.nvim_create_user_command('PhpactorLSPServerStatus', extension.status, {nargs = 0})
vim.api.nvim_create_user_command('PhpactorLSPServerReindex', extension.reindex, {nargs = 0})

return extension
