local api = vim.api

local augroup = api.nvim_create_augroup('ArctgxFiletypeDetect', {clear = true})

api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '~/.src/arctgx/dconf/dump',
  group = augroup,
  callback = function ()
    vim.bo.filetype = 'config'
  end
})

api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '*.yml.dist',
  group = augroup,
  callback = function ()
    vim.bo.filetype = 'yaml'
  end
})

api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = 'composer.lock',
  group = augroup,
  callback = function ()
    vim.bo.filetype = 'json'
  end
})
