local arctgxLsp = require 'arctgx.lsp'
local configs = require 'lspconfig.configs'
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

require('lspconfig.ui.windows').default_options.border = 'rounded'

local capabilities = arctgxLsp.defaultClientCapabilities()

lspconfig.jsonls.setup {
  filetypes = {'json', 'jsonc'},
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}

lspconfig.lemminx.setup {
  capabilities = capabilities,
}

configs.phpactor = {
  default_config = {
    autostart = true,
    cmd_env = {
      XDG_CACHE_HOME = '/tmp'
    },
    cmd = {
      -- 'phpxx',
      vim.uv.fs_realpath(vim.fn.exepath('phpactor')) or 'phpactor',
      'language-server',
      -- '-vvv',
    },
    filetypes = {'php'},
    root_dir = function (pattern)
      local cwd = vim.uv.cwd()
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
}

lspconfig.yamlls.setup {
  capabilities = capabilities,
  settings = {
    ['yaml.schemastore.enable'] = true,
    ['yaml.schemas'] = {
      -- ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose.yml',
    },
  }
}

lspconfig.lua_ls.setup {
  -- cmd = {'lua-language-server', '--loglevel=trace'},
  -- trace = 'verbose',
  on_init = require('arctgx.lsp.serverConfigs.luaLs').onInit
}

local servers = {
  'bashls',
  'vimls',
  'dockerls',
  'tsserver',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
