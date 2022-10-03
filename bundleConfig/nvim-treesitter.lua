require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'dockerfile',
    'help',
    'http',
    'javascript',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'php',
    'phpdoc',
    'python',
    'query',
    'sql',
    'teal',
    'todotxt',
    'twig',
    'vim',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<Plug>(treesitter-init-selection)',
      node_incremental = '<Plug>(treesitter-node-incremental)',
      node_decremental = '<Plug>(treesitter-node-decremental)',
      scope_incremental = '<Plug>(treesitter-scope-incremental)',
    },
  },
  indent = {
    enable = true,
  },
}

vim.opt.foldmethod='expr'
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
