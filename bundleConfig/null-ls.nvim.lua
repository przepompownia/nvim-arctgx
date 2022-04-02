local null_ls = require('null-ls')
local util = require('lspconfig.util')

local function phpProjectRoot(pattern)
  local cwd = vim.loop.cwd()
  local root = util.root_pattern('composer.json', '.git')(pattern.bufname)

  -- returned = util.path.is_descendant(cwd, root) and cwd or root
  -- print(vim.inspect(util.path.is_descendant(cwd, root)))
  return root
end

local phpcsArgs = {
  extra_args = {
    "--standard=" .. os.getenv('HOME') .. '/.php-cs-ruleset.xml',
  },
  -- cwd = phpProjectRoot,
}

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.php,
    null_ls.builtins.formatting.phpcsfixer,
    null_ls.builtins.formatting.phpcbf.with(phpcsArgs),
    null_ls.builtins.diagnostics.phpcs.with(phpcsArgs),
    null_ls.builtins.diagnostics.phpmd,
    null_ls.builtins.diagnostics.phpstan,
  }
})
