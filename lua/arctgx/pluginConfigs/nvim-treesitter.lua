require('nvim-treesitter').setup({})

require('nvim-treesitter.install').install(
  require('nvim-treesitter.config').norm_languages(require('arctgx.treesitter').langs(), {installed = true}),
  {},
  function ()
    vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
  end
)
