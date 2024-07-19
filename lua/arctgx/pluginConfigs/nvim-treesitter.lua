local additionalParsers = {
  'awk',
  'bash',
  'diff',
  'dockerfile',
  'editorconfig',
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
  'luadoc',
  'make',
  'muttrc',
  'passwd',
  'php_only',
  'phpdoc',
  'python',
  'regex',
  'sql',
  'strace',
  'ssh_config',
  'tmux',
  'todotxt',
  'toml',
  'udev',
  'twig',
  'xml',
  'yaml',
}

local keymap = require('arctgx.vim.abstractKeymap')
local tsKeymaps = {
  init_selection = keymap.firstLhs('langIncrementSelection'),
  node_incremental = keymap.firstLhs('langIncrementSelection'),
  node_decremental = keymap.firstLhs('langDecrementSelection'),
  scope_incremental = keymap.firstLhs('langScopeIncrementSelection'),
}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = additionalParsers,
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

local tsLangMap = {
  php = 'php_only',
}

for filetype, lang in pairs(tsLangMap) do
  if filetype ~= lang then
    vim.treesitter.language.register(lang, filetype)
  end
end
