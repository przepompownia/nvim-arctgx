vim.api.nvim_create_autocmd('OptionSet', {
  once = true,
  pattern = 'termguicolors',
  callback = function ()
    if vim.go.termguicolors then
      require 'colorizer'.setup()
    end
  end,
})
