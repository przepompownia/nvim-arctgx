local api = vim.api

local function dumpConfig()
  vim.lsp.buf_request_all(0, 'phpactor/debug/config', {['return'] = true}, function (result)
    for _, data in pairs(result) do
      require('arctgx.base').displayInWindow('Phpactor LSP Configuration', 'json', data.result)
    end
  end)
end

local function status()
  vim.lsp.buf_request_all(0, 'phpactor/status', {['return'] = true}, function (result)
    for _, data in pairs(result) do
      require('arctgx.base').displayInWindow('Phpactor Status', 'markdown', data.result)
    end
  end)
end

local function reindex()
  vim.lsp.buf_notify(0, 'phpactor/indexer/reindex', {})
end

return {
  cmd = {
    -- 'phpxx',
    vim.uv.fs_realpath(vim.fn.exepath('phpactor')) or 'phpactor',
    'language-server',
    -- '-vvv',
  },
  -- trace = 'verbose',
  log_level = vim.lsp.protocol.MessageType.Warning,
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
    -- ['indexer.searcher_semi_fuzzy'] = true,
  },
  on_attach = function (_, bufnr)
    api.nvim_buf_create_user_command(bufnr, 'PhpactorLSPDumpConfig', dumpConfig, {nargs = 0})
    api.nvim_buf_create_user_command(bufnr, 'PhpactorLSPServerStatus', status, {nargs = 0})
    api.nvim_buf_create_user_command(bufnr, 'PhpactorLSPServerReindex', reindex, {nargs = 0})
  end
}
