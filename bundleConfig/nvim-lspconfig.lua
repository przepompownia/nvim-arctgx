local nvim_lsp = require('lspconfig')

local vim = vim
local api = vim.api
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'

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
  local bufnr = vim.uri_to_bufnr(uri)
  -- Save position in jumplist
  vim.cmd "normal! m'"

  -- Push a new item into tagstack
  -- local from = {vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0}
  -- local items = {{tagname=vim.fn.expand('<cword>'), from=from}}
  -- vim.fn.settagstack(vim.fn.win_getid(), {items=items}, 't')

  --- Jump to new location (adjusting for UTF-16 encoding of characters)
  -- api.nvim_set_current_buf(bufnr)
  -- api.nvim_buf_set_option(0, 'buflisted', true)
  -- api.nvim_command('TabDrop '..vim.uri_to_fname(uri))
  api.nvim_command('call arctgx#base#tabDrop("'..vim.uri_to_fname(uri)..'")')
  local range = location.range or location.targetSelectionRange
  local row = range.start.line
  local col = get_line_byte_from_position(0, range.start)
  api.nvim_win_set_cursor(0, {row + 1, col})
  return true
end

local location_handler = function(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if vim.tbl_islist(result) then
    tab_drop_location(result[1])

    if #result > 1 then
      util.set_qflist(util.locations_to_items(result))
      api.nvim_command("copen")
    end
  else
    tab_drop_location(result)
  end
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-goto-definition)', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-hover)', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-goto-implementation)', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-show-signature-help)', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-action-rename)', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-find-references)', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Plug>(ide-diagnostic-info)', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end
--see: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_declaration
vim.lsp.handlers['textDocument/declaration'] = location_handler
vim.lsp.handlers['textDocument/definition'] = location_handler
vim.lsp.handlers['textDocument/typeDefinition'] = location_handler
vim.lsp.handlers['textDocument/implementation'] = location_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false
  }
)
vim.lsp.set_log_level('debug')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.sqls.setup{
  cmd = {"$HOME/go/bin/sqls", "-config", "$HOME/.config/sqls/config.yml"};
  capabilities = capabilities,
  on_attach = on_attach,
}

require'lspconfig'.diagnosticls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'php' },
  init_options = {
    filetypes = {
      php = {
        'phpmd',
        'phpcs',
        'phpstan',
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
          '--autoload-file',
          '.ide/phpstan-bootstrap.php',
          '--level',
          'max',
          '--error-format',
          'raw',
          '--no-progress',
          '%file'
        },
        offsetLine = 0,
        offsetColumn = 0,
        formatLines = 1,
        formatPattern = {
          '^[^:]+:(\\d+):(.*)(\\r|\\n)*$',
          {
            line = 1,
            message = 2,
          }
        },
      },
    }
  }
}

-- todo check if path exist
local sumneko_root_path = os.getenv( "HOME" )..'/dev/external/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  autostart = false,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  capabilities = capabilities,
  on_attach = on_attach,
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
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

local servers = { 'bashls', 'vimls', 'dockerls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

vim.cmd([[
  sign define DiagnosticSignHint text=💡 linehl= texthl=IdeHintSign numhl=IdeLineNrHint
  sign define DiagnosticSignInfo text=🛈  linehl= texthl=IdeInfoSign numhl=IdeLineNrInfo
  sign define DiagnosticSignWarn text=⚠ linehl= texthl=IdeWarningSign numhl=IdeLineNrWarning
  sign define DiagnosticSignError text=✗ linehl= texthl=IdeErrorSign numhl=IdeLineNrError
]])
