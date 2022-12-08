local null = require('null-ls')
local generators = require('null-ls.generators')
local methods = require('null-ls.methods')
local util = require('lspconfig.util')
local base = require('arctgx.base')
local api = vim.api

local function phpProjectRoot(pattern)
  local cwd = vim.loop.cwd()
  local root = util.root_pattern('composer.json', '.git')(pattern.bufname)

  -- returned = util.path.is_descendant(cwd, root) and cwd or root
  -- print(vim.inspect(util.path.is_descendant(cwd, root)))
  return root
end

local phpcsArgs = {
  extra_args = {
    '--standard=' .. os.getenv('HOME') .. '/.php-cs-ruleset.xml',
  },
}

null.setup({
  -- debug = true,
  diagnostics_format = '#{s}: #{m} [#{c}]',
  update_in_insert = false,
  sources = {
    null.builtins.code_actions.shellcheck,
    null.builtins.code_actions.eslint,
    null.builtins.diagnostics.tidy,
    null.builtins.diagnostics.twigcs,
    null.builtins.diagnostics.eslint,
    null.builtins.diagnostics.jsonlint,
    null.builtins.diagnostics.phpcs.with(phpcsArgs),
    null.builtins.diagnostics.phpmd.with({
      extra_args = {'cleancode,codesize,controversial,design,naming,unusedcode'}
    }),
    null.builtins.diagnostics.phpstan.with({
      timeout = 10000,
      debounce = 3000,
      cwd = phpProjectRoot,
      args = {
        'analyze',
        '--level',
        'max',
        '--error-format',
        'json',
        '--no-progress',
        '--no-interaction',
        -- '--',
        '$FILENAME',
      },
    }),
    null.builtins.diagnostics.shellcheck,
    null.builtins.diagnostics.vint,
    null.builtins.formatting.lua_format,
    null.builtins.formatting.phpcbf.with(phpcsArgs),
    null.builtins.formatting.phpcsfixer.with({cwd = phpProjectRoot}),
    -- null.builtins.formatting.prettier.with({
    --   extra_filetypes = {
    --     'php',
    --   },
    -- }),
    -- null.builtins.formatting.prettier_d_slim.with({
    --   extra_filetypes = {
    --     'php',
    --   },
    -- }),
    null.builtins.formatting.shfmt,
    null.builtins.formatting.stylua,
    null.builtins.formatting.xmllint,
  },
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/discussions/236
local chooseFormatter = function(range)
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

  local method = methods.internal.FORMATTING
  local available = generators.get_available(filetype, method)
  local formatters = {}

  for _, formatter in ipairs(available) do
    formatters[formatter.opts.command] = formatter
  end

  local onSelect = function(selected)
    if not selected then
      return
    end

    for command, formatter in ipairs(formatters) do
      formatter._disabled = command ~= selected or nil
    end

    -- pcall(vim.lsp.buf.format, { name = 'null-ls' })
    vim.lsp.buf.format({name = 'null-ls', range = range})

    for _, formatter in ipairs(formatters) do
      formatter._disabled = nil
    end
  end

  local choices = vim.tbl_keys(formatters)
  table.sort(choices)
  vim.ui.select(choices, {prompt = 'Run formatter: '}, onSelect)
end

vim.keymap.set({'n'}, '<Plug>(ide-format-with-selected-formatter)', chooseFormatter)
vim.keymap.set({'v'}, '<Plug>(ide-format-with-selected-formatter)', function ()
  chooseFormatter(base.getVisualSelectionRange())
end)
api.nvim_create_user_command('NullLsSelectFormatter', chooseFormatter, {nargs = '*'})
