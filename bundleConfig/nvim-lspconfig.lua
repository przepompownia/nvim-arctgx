local arctgxLsp = require 'arctgx.lsp'
local configs = require 'lspconfig.configs'
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local vim = vim

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.jsonls.setup {
  filetypes = { 'json', 'jsonc' },
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}

lspconfig.lemminx.setup {
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
}

configs.phpactor = {
  default_config = {
    autostart = true,
    cmd_env = {
      XDG_CACHE_HOME = '/tmp'
    },
    cmd = {
      -- 'phpxx',
      os.getenv('HOME')..'/.vim/pack/bundle/opt/phpactor/bin/phpactor',
      'language-server',
      -- '-vvv',
    },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git')(pattern)

      return util.path.is_descendant(cwd, root) and cwd or root
    end,
    init_options = {
      ['logging.path'] = '/tmp/phpactor.log',
    },
  },
}

lspconfig.phpactor.setup {
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
}

lspconfig.sqls.setup {
  cmd = {os.getenv('HOME') .. '/go/bin/sqls', '-config', os.getenv('HOME') .. '/.config/sqls/config.yml'};
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
}

lspconfig.diagnosticls.setup {
  -- cmd = {
    -- os.getenv('HOME') .. '/dev/external/diagnostic-languageserver/bin/index.js',
    '--stdio',
    -- '--log-level',
    -- '4',
  -- },
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
  filetypes = {
    'php',
  },
  init_options = {
    filetypes = {
      php = {
        'phpmd',
        'phpcs',
        'phpstan',
      },
    },
    formatFiletypes = {
      php = {
        'cs-fixer',
      },
    },
    formatters = {
      ['cs-fixer'] = {
        sourceName = 'php-cs-fixer',
        command = 'php-cs-fixer',
        args = {
          'fix',
          '%file', -- with '-' trailing ^M are added
        },
        rootPatterns = { 'composer.json', 'composer.lock', 'vendor' },
        requiredFiles = {'.php-cs-fixer.dist.php', '.php-cs-fixer.php'},
        debounce = 100,
        isStdout = false,
        isStderr = false,
        doesWriteToFile = true,
      },
    },
    linters = {
      phpcs = {
        sourceName = 'phpcs',
        command = 'phpcs',
        rootPatterns = { 'composer.json', 'composer.lock', 'vendor', '.git' },
        debounce = 100,
        args = {
          '--standard=PSR12',
          '--report=json',
          '-s',
          '-',
        },
        parseJson = {
          errorsRoot = 'files.STDIN.messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[phpcs] ${message} [${source}]',
          security = 'type',
        },
        securities = {
          ERROR = 'error',
          WARNING = 'warning'
        }
      },
      phpmd = {
        sourceName = 'phpmd',
        command = 'phpmd',
        rootPatterns = { 'composer.json', 'composer.lock', 'vendor', '.git' },
        debounce = 100,
        args = {
          '%filepath',
          'json',
          'cleancode,codesize,controversial,design,naming,unusedcode',
        },
        securities = {
          [1] = 'error',
          [2] = 'warning',
          [3] = 'info',
          [4] = 'hint',
          [5] = 'hint'
        },
        parseJson = {
          errorsRoot = 'files[0].violations',
          line = 'beginLine',
          -- column = 'column',
          -- endLine = 'endLine',
          -- endColumn = 'endColumn',
          message = '[phpmd] ${description} [${rule}] [${ruleSet}] [${externalInfoUrl}]',
          security = 'priority',
        },
      },
      phpstan = {
        sourceName = 'phpstan',
        command = 'phpstan',
        -- command = '/tmp/phpstan.php',
        rootPatterns = { 'phpstan.neon', 'composer.json', 'composer.lock', 'vendor', '.git' },
        debounce = 100,
        args = {
          'analyze',
          -- '--autoload-file',
          -- '.ide/phpstan-bootstrap.php',
          '--level',
          'max',
          '--error-format',
          'json',
          '--no-progress',
          '--no-interaction',
          '--',
          '%file',
        },
        parseJson = {
          errorsRoot = 'files[\"%filepath\"].messages',
          line = 'line',
          message = '[phpstan] ${message}',
          -- security = 'ignorable',
        },
        -- securities = {
          -- true = 'error',
          -- false = 'warning',
        -- },
      },
    }
  }
}

lspconfig.yamlls.setup {
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
  settings = {
    ['yaml.schemastore.enable'] = true,
    ['yaml.schemas'] = {
      -- ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose.yml',
    },
  }
}

-- todo check if path exist
-- local sumnekoRoot = os.getenv( 'HOME' ) .. '/dev/external/lua-language-server'
-- local sumnekoBinary = sumnekoRoot .. '/bin/Linux/lua-language-server'
local sumnekoRoot = os.getenv( 'HOME' ) .. '/dev/external/lua-language-server-releases/2.6.6'
local sumnekoBinary = sumnekoRoot .. '/bin/lua-language-server'

local runtimePath = vim.split(package.path, ';')
table.insert(runtimePath, 'lua/?.lua')
table.insert(runtimePath, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
  autostart = true,
  cmd = {
    sumnekoBinary,
    -- '--logpath=/tmp/sumneko_lua.log',
    '-E',
    sumnekoRoot .. '/main.lua',
    '--preview',
  };
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtimePath,
      },
      diagnostics = {
        globals = {'vim'},
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

local servers = { 'bashls', 'vimls', 'dockerls', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = arctgxLsp.onAttach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
