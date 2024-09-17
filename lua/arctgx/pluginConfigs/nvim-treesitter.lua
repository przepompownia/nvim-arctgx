local additionalParsers = {
  'awk',
  'bash',
  'c',
  'css',
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
  'markdown',
  'markdown_inline',
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
  'vim',
  'xml',
  'yaml',
}

local ftLangMap = {
  php = 'php_only',
}

local notFileType = {
  php_only = true,
}

for _, parser in ipairs(additionalParsers) do
  if nil == notFileType[parser] then
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
  require('nvim-treesitter').setup({
    ignore_install = {
      'markdown',
      'markdown_inline',
      'c',
      'vim',
    },
  })

  require('nvim-treesitter.install').install(
    vim.tbl_values(ftLangMap),
    {skip = {installed = true, ignored = true}},
    function ()
      vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
    end
  )

  vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.tbl_keys(ftLangMap),
    callback = function (event)
      local ok, error = pcall(vim.treesitter.start, event.buf, ftLangMap[event.match])
      if ok then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        return
      end

      if not error:find('no parser') then
        return
      end

      vim.api.nvim_create_autocmd('User', {
        buffer = event.buf,
        callback = function (tsinstallEvent)
          if not tsinstallEvent.match == 'TSInstallFinished' then
            return
          end
          vim.treesitter.start(event.buf, ftLangMap[event.match])
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      })
    end
  })
end

if require('nvim-treesitter.install').install then
  configureMain()
  return
end
configureMaster()
