local langs = require('arctgx.treesitter').langs()

local function configureMain()
  require('nvim-treesitter').setup({})

  require('nvim-treesitter.install').install(
    langs,
    {skip = {installed = true}},
    function ()
      vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
    end
  )
end

local function configureMaster()
  local keymap = require('arctgx.vim.abstractKeymap')
  local tsKeymaps = {
    init_selection = keymap.firstLhs('langIncrementSelection'),
    node_incremental = keymap.firstLhs('langIncrementSelection'),
    node_decremental = keymap.firstLhs('langDecrementSelection'),
    scope_incremental = keymap.firstLhs('langScopeIncrementSelection'),
  }

  require 'nvim-treesitter.configs'.setup {
    ensure_installed = langs,
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = tsKeymaps,
    },
    indent = {
      enable = true,
    },
  }
end

if require('nvim-treesitter.install').install then
  configureMain()
  return
end
configureMaster()
