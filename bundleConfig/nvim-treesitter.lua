require'nvim-treesitter.configs'.setup {
  ensure_installed = {'dockerfile', 'php', 'lua', 'javascript', 'json', 'jsonc', 'python', 'vim', 'bash', 'yaml'},
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
  },
}

vim.cmd([[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
]])
