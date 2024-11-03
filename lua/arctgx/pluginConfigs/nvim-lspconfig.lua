local arctgxLsp = require 'arctgx.lsp'
local configs = require 'lspconfig.configs'
local lspconfig = require('lspconfig')

require('lspconfig.ui.windows').default_options.border = 'rounded'

lspconfig.jsonls.setup {
  filetypes = {'json', 'jsonc'},
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}

lspconfig.lemminx.setup {}

configs.phpactor = {
  default_config = vim.tbl_extend(
    'keep',
    {
      autostart = true,
      root_dir = function (file)
        return require('arctgx.lsp').findRoot(file, require('arctgx.lsp.serverConfigs.phpactor').defaultRootPatterns)
      end,
      filetypes = {'php'},
    },
    require('arctgx.lsp.serverConfigs.phpactor').clientConfig()
  ),
}

lspconfig.phpactor.setup {}

lspconfig.yamlls.setup {
  capabilities = capabilities,
  settings = {
    ['yaml.schemastore.enable'] = true,
    ['yaml.schemas'] = {
      -- ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose.yml',
    },
  }
}

local servers = {
  'bashls',
  'vimls',
  'dockerls',
  'ts_ls',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    flags = {
      debounce_text_changes = 150,
    }
  }
end
