local null = require('null-ls')
local base = require('arctgx.base')
local api = vim.api

local function phpProjectRoot(pattern)
  -- local cwd = vim.uv.cwd()
  local root = require('lspconfig.util').root_pattern('composer.json', '.git')(pattern.bufname)

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
    null.builtins.completion.nvim_snippets.with({
      filetypes = require('arctgx.pluginConfigs.nvim-snippets').filetypes,
    }),
    null.builtins.diagnostics.tidy,
    null.builtins.diagnostics.twigcs,
    -- null.builtins.diagnostics.phpcs.with(phpcsArgs),
    null.builtins.diagnostics.phpmd.with({
      extra_args = {'cleancode,codesize,controversial,design,naming,unusedcode'}
    }),
    -- null.builtins.diagnostics.phpstan.with({
    --   temp_dir = '/tmp',
    --   timeout = 10000,
    --   debounce = 3000,
    --   cwd = phpProjectRoot,
    --   args = {
    --     'analyze',
    --     '--level',
    --     'max',
    --     '--error-format',
    --     'json',
    --     '--no-progress',
    --     '--no-interaction',
    --     -- '--',
    --     '$FILENAME',
    --   },
    -- }),
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
    null.builtins.formatting.xmllint,
  },
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/discussions/236
local chooseFormatter = function (range)
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype

  local method = require('null-ls.methods').internal.FORMATTING
  local available = require('null-ls.generators').get_available(filetype, method)
  local formatters = {}

  for _, formatter in ipairs(available) do
    formatters[formatter.opts.command] = formatter
  end

  local onSelect = function (selected)
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

require('arctgx.vim.abstractKeymap').set({'n'}, 'langApplySelectedformatter', chooseFormatter)
require('arctgx.vim.abstractKeymap').set({'v'}, 'langApplySelectedformatter', function ()
  chooseFormatter(base.getVisualSelectionRange())
end)
api.nvim_create_user_command('NullLsSelectFormatter', chooseFormatter, {nargs = '*'})
