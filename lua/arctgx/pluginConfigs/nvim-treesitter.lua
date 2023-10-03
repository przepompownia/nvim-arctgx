require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'awk',
    'bash',
    'diff',
    'dockerfile',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'git_rebase',
    'git_config',
    'html',
    'http',
    'ini',
    'javascript',
    'jq',
    'json',
    'json5',
    'jsonc',
    'lua',
    'luadoc',
    'make',
    'markdown',
    'markdown_inline',
    'passwd',
    'php',
    'phpdoc',
    'python',
    'regex',
    'query',
    'sql',
    'strace',
    'ssh_config',
    'todotxt',
    'toml',
    'twig',
    'vim',
    'vimdoc',
    'xml',
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

-- -- require 'nvim-treesitter.install'.compilers = { 'clang' }
-- local parserConfig = require 'nvim-treesitter.parsers'.get_parser_configs()
-- parserConfig.php = {
--   install_info = {
--     url = '~/dev/external/tree-sitter-php',
--     files = {'src/parser.c', 'src/scanner.cc'},
--     branch = 'array',
--     generate_requires_npm = false,
--     requires_generate_from_grammar = false,
--   },
--   filetype = 'php', -- if filetype does not match the parser name
-- }
