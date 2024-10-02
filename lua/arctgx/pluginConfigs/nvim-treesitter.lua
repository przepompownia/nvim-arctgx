local langs = require('arctgx.treesitter').langs()

require('nvim-treesitter').setup({})

require('nvim-treesitter.install').install(
  langs,
  {skip = {installed = true}},
  function ()
    vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
  end
)
