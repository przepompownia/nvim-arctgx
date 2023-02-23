local augroup = vim.api.nvim_create_augroup('ArctgxFiletypeDetect', {clear = true})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '~/.src/arctgx/dconf/dump',
  group = augroup,
  callback = function ()
    vim.bo.filetype = 'config'
  end
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '*.yml.dist',
  group = augroup,
  callback = function ()
    vim.bo.filetype = 'yaml'
  end
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = 'composer.lock',
  group = augroup,
  callback = function ()
    vim.bo.filetype = 'json'
  end
})
