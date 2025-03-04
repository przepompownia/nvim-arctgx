local config = {}

config.filetypes = {'lua', 'php', 'markdown'}

require('snippets').setup({
  global_snippets = nil,
  create_autocmd = false,
  create_cmp_source = false,
  allowed_filetypes = config.filetypes,
  search_paths = {
    vim.fs.joinpath(require('arctgx.base').getPluginDir(), 'snippets'),
  },
})

return config
