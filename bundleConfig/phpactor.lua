local augroup = vim.api.nvim_create_augroup('Phpactor', {clear = true})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  group = augroup,
  callback = function (opts)
    vim.keymap.set('n', '<Plug>(ide-class-new)', require('arctgx.phpactor').classNew, {buffer = opts.buf})

  end
})
