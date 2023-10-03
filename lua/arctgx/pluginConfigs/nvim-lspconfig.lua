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
      vim.uv.fs_realpath(vim.fn.exepath('phpactor')) or 'phpactor',
      'language-server',
      -- '-vvv',
    },
    filetypes = { 'php' },
    root_dir = function(pattern)
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

lspconfig.lua_ls.setup {
  on_attach = arctgxLsp.onAttach,
  on_init = function (client)
    local path = client.workspace_folders[1].name

    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return true
    end

    vim.notify('.luarc.json(c) not found')
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
      Lua = {
        runtime = {
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
          version = 'LuaJIT',
          pathStrict = true,
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- include generated table from JSON file
          },
          maxPreload = 10000,
          preloadFileSize = 10000,
        },
        window = {
          statusBar = false,
          progressBar = false,
        },
        hint = {
          enable = true,
        },
        diagnostics = {
          unusedLocalExclude = '_*',
          neededFileStatus = {
            ['codestyle-check'] = 'Any',
          },
        },
      }
    })

    client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})
  end
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
    on_attach = arctgxLsp.onAttach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
