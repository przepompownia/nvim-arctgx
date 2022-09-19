local null = require('null-ls')
local util = require('lspconfig.util')
local sources = require('null-ls.sources')

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
  diagnostics_format = "#{s}: #{m} [#{c}]",
  update_in_insert = false,
  sources = {
    null.builtins.code_actions.shellcheck,
    null.builtins.code_actions.eslint,
    null.builtins.diagnostics.eslint,
    null.builtins.diagnostics.jsonlint,
    null.builtins.diagnostics.php.with({
      check_exit_code = function (code)
        vim.schedule(function ()
          local filter = {name = 'phpmd'}
          local phpmd = sources.get(filter)
          if {} == phpmd then
            return
          end

          if 0 == code and true == phpmd[1]._disabled then
            sources.enable(filter)
            return
          end
          sources.disable(filter)
        end)
      end
    }),
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
      }
    }),
    null.builtins.diagnostics.shellcheck,
    null.builtins.diagnostics.vint,
    null.builtins.formatting.phpcbf.with(phpcsArgs),
    null.builtins.formatting.phpcsfixer.with({cwd = phpProjectRoot}),
    null.builtins.formatting.prettier,
    null.builtins.formatting.shfmt,
  }
})
