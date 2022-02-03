local arctgx_lsp = require 'arctgx.lsp'
local nvim_lsp = require('lspconfig')
local vim = vim

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig').jsonls.setup {
  filetypes = { 'json', 'jsonc' },
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}

require'lspconfig'.lemminx.setup {
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
}

require'lspconfig'.sqls.setup{
  cmd = {os.getenv('HOME')..'/go/bin/sqls', '-config', os.getenv('HOME')..'/.config/sqls/config.yml'};
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
}

require'lspconfig'.diagnosticls.setup{
  -- cmd = {
    -- '/home/arctgx/dev/external/diagnostic-languageserver/bin/index.js',
    '--stdio',
    -- '--log-level',
    -- '4',
  -- },
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
  filetypes = { 'php' },
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

require('lspconfig').yamlls.setup {
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
  settings = {
    ['yaml.schemastore.enable'] = true,
    ['yaml.schemas'] = {
  }
}

-- todo check if path exist
local sumneko_root_path = os.getenv( 'HOME' )..'/dev/external/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require'lspconfig'.sumneko_lua.setup {
  autostart = true,
  cmd = {
    sumneko_binary,
    -- '--logpath=/tmp/sumneko_lua.log',
    '-E',
    sumneko_root_path .. '/main.lua',
  };
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = {'vim'},
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
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = arctgx_lsp.on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
