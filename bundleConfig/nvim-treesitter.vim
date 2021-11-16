lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'dockerfile', 'php', 'lua', 'javascript', 'json', 'jsonc', 'python', 'vim', 'bash'},
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
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
