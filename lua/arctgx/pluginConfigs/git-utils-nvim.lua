local base = require 'arctgx.base'
local keymap = require('arctgx.vim.abstractKeymap')
keymap.set('n', 'gitCommit', function ()
  local cwd = require('arctgx.git').top(require('arctgx.base').getBufferCwd())
  require('git-utils.commit')({gitDir = cwd})
end)

require('telescope').load_extension('git_utils')
vim.api.nvim_create_user_command(
  'GTDiff',
  function (opts)
    require('git-utils.telescope.gdiff').run({
      args = opts.fargs,
      cwd = require('arctgx.git').top(base.getBufferCwd()),
      attach_mappings = require('arctgx.telescope').defaultFileMappings,
    })
  end,
  {
    nargs = '*',
    complete = function (argLead, _, _)
      local git = require('arctgx.git')
      return git.matchBranchesToRange(git.top(base.getBufferCwd()), argLead)
    end,
  }
)
