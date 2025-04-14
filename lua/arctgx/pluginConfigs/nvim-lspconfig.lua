local servers = {
  'autotools_ls',
  'bashls',
  'vimls',
  'dockerls',
  'ts_ls',
  'clangd',
  'twiggy_language_server',
  'smarty_ls',
  'marksman',
  'phpactor',
  'lemminx',
  'jsonls',
  'yamlls',
  -- 'harper_ls',
  -- 'sqls',
}
for _, name in ipairs(servers) do
  vim.lsp.enable(name)
end
