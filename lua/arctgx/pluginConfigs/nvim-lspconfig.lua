local arctgxLsp = require 'arctgx.lsp'
local configs = require 'lspconfig.configs'
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local vim = vim

require('lspconfig.ui.windows').default_options.border = 'rounded'

local capabilities = arctgxLsp.defaultClientCapabilities()

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
      vim.loop.fs_realpath(vim.fn.exepath('phpactor')),
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
      ['completion_worse.completor.keyword.enabled'] = true,
      ['phpunit.enabled'] = true,
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

local neodevOk, neodev = pcall(require, 'neodev')
if neodevOk then
  neodev.setup({
    override = function (root_dir, options)
      -- vim.notify('Neodev root_dir: ' .. root_dir, vim.log.levels.INFO)
      options.plugins = true
    end
  })
end

lspconfig.lua_ls.setup {
  autostart = true,
  capabilities = capabilities,
  on_attach = arctgxLsp.onAttach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        -- library = getLuaRuntime(),
        maxPreload = 10000,
        preloadFileSize = 10000,
        -- library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      completion = {
        showWord = 'Disable',
        postfix = '.',
      },
      diagnostics = {
        globals = {'vim'},
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
      telemetry = {
        enable = false,
      },
      window = {
        statusBar = false,
        progressBar = false,
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
