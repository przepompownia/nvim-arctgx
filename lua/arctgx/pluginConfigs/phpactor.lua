local augroup = vim.api.nvim_create_augroup('Phpactor', {clear = true})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  group = augroup,
  callback = function (opts)
    require('arctgx.vim.abstractKeymap').set(
      'n',
      'langClassNew',
      require('arctgx.lsp.serverConfigs.phpactor').classNew,
      {buffer = opts.buf}
    )
  end
})
