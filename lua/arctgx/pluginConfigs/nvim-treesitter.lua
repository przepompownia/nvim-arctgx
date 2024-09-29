local fileTypes = {
  'awk',
  'bash',
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
  'make',
  'muttrc',
  'passwd',
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

local notFtLangs = {
  'luadoc',
  'phpdoc',
  'php_only',
}

local additionalFiletypes = {
  'php',
  'markdown',
  'markdown_inline',
  'c',
  'vim',
}

local ftLangMap = {
  php = 'php_only',
}

local langs = vim.deepcopy(fileTypes)

for _, lang in ipairs(notFtLangs) do
  langs[#langs + 1] = lang
end

for _, fileType in ipairs(additionalFiletypes) do
  fileTypes[#fileTypes + 1] = fileType
end

for filetype, lang in pairs(ftLangMap) do
  vim.treesitter.language.register(lang, filetype)
end

local function configureMain()
  require('nvim-treesitter').setup({})

  require('nvim-treesitter.install').install(
    langs,
    {skip = {installed = true}},
    function ()
      vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
    end
  )

  vim.api.nvim_create_autocmd('FileType', {
    pattern = fileTypes,
    callback = function (event)
      local function start(buf, lang)
        vim.treesitter.start(buf, lang)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local lang = vim.treesitter.language.get_lang(event.match)

      if vim.treesitter.language.add(lang) then
        start(event.buf, lang)
        return
      end

      vim.api.nvim_create_autocmd('User', {
        once = true,
        buffer = event.buf,
        callback = function (tsinstallEvent)
          if tsinstallEvent.match == 'TSInstallFinished' then
            start(event.buf, lang)
          end
        end
      })
    end
  })
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
