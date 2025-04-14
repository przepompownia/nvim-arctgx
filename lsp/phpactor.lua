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
}
