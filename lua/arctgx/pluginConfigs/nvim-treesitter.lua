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

local ftLangMap = {
  php = 'php_only',
}

local notFtiletype = {
  php_only = true,
}

for _, parser in ipairs(additionalParsers) do
  if nil == notFtiletype[parser] then
    ftLangMap[parser] = parser
  end
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
end

for filetype, lang in pairs(ftLangMap) do
  if filetype ~= lang then
    vim.treesitter.language.register(lang, filetype)
  end
end

local function configureMain()
  require('nvim-treesitter').setup()

  require('nvim-treesitter.install').install(vim.tbl_values(ftLangMap), {skip = {installed = true}}, function ()
    vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
  end)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.tbl_keys(ftLangMap),
    callback = function (event)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      local ok, error = pcall(vim.treesitter.start, event.buf, ftLangMap[event.match])
      if not ok and error:find('no parser') then
        vim.api.nvim_create_autocmd('User', {
          buffer = event.buf,
          callback = function (tsinstallEvent)
            if not tsinstallEvent.match == 'TSInstallFinished' then
              return
            end
            vim.treesitter.start(event.buf, ftLangMap[event.match])
          end
        })
      end
    end
  })
end

if require('nvim-treesitter.install').install then
  configureMain()
  return
end
configureMaster()
