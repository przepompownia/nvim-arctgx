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

vim.lsp.enable('phpactor')

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
