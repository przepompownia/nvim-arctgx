local keymap = require('arctgx.vim.abstractKeymap')
keymap.set('n', 'gitCommit', function ()
  local cwd = require('arctgx.git').top(require('arctgx.base').getBufferCwd())
  require('git-utils.commit')({gitDir = cwd})
end)

require('telescope').load_extension('git_utils')
