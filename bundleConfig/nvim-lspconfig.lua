local base = require('arctgx.base')
local nvim_lsp = require('lspconfig')

local vim = vim
local api = vim.api
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'
local arctgx_lsp = require 'arctgx.lsp'

local function get_line_byte_from_position(bufnr, position)
  -- LSP's line and characters are 0-indexed
  -- Vim's line and columns are 1-indexed
  local col = position.character
  -- When on the first character, we can ignore the difference between byte and
  -- character
  if col > 0 then
    local line = position.line
    local lines = api.nvim_buf_get_lines(bufnr, line, line + 1, false)
    if #lines > 0 then
      return vim.str_byteindex(lines[1], col)
    end
  end
  return col
end

-- stolen from nvim/**/vim/lsp/util.lua
local tab_drop_location = function(location)
  -- location may be Location or LocationLink
  local uri = location.uri or location.targetUri
  if uri == nil then return end
  -- Save position in jumplist
  vim.cmd "normal! m'"

  -- Push a new item into tagstack
  -- local from = {vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0}
  -- local items = {{tagname=vim.fn.expand('<cword>'), from=from}}
  -- vim.fn.settagstack(vim.fn.win_getid(), {items=items}, 't')

  --- Jump to new location (adjusting for UTF-16 encoding of characters)
  base.tab_drop(vim.uri_to_fname(uri))
  local range = location.range or location.targetSelectionRange
  local row = range.start.line
  local col = get_line_byte_from_position(0, range.start)
  api.nvim_win_set_cursor(0, {row + 1, col})

  return true
end

local function location_handler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')

    return nil
  end

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if not vim.tbl_islist(result) then
    tab_drop_location(result)

    return
  end

  if #result == 1 then
    tab_drop_location(result[1])

    return
  end

  vim.fn.setqflist({}, ' ', {title = 'LSP locations', items = util.locations_to_items(result)})
  api.nvim_command('copen')
end

vim.lsp.handlers['textDocument/declaration'] = location_handler
vim.lsp.handlers['textDocument/definition'] = location_handler
vim.lsp.handlers['textDocument/typeDefinition'] = location_handler
vim.lsp.handlers['textDocument/implementation'] = location_handler
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = false,
  }
)
-- vim.lsp.set_log_level('debug')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.sqls.setup{
  cmd = {os.getenv('HOME')..'/go/bin/sqls', '-config', os.getenv('HOME')..'/.config/sqls/config.yml'};
  capabilities = capabilities,
  on_attach = arctgx_lsp.on_attach,
}

require'lspconfig'.diagnosticls.setup{
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

vim.cmd([[
  sign define DiagnosticSignHint text=💡 linehl= texthl=IdeHintSign numhl=IdeLineNrHint
  sign define DiagnosticSignInfo text=🛈  linehl= texthl=IdeInfoSign numhl=IdeLineNrInfo
  sign define DiagnosticSignWarn text=⚠ linehl= texthl=IdeWarningSign numhl=IdeLineNrWarning
  sign define DiagnosticSignError text= linehl= texthl=IdeErrorSign numhl=IdeLineNrError
]])
