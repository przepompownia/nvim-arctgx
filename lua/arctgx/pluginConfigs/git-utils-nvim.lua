local keymap = require('arctgx.vim.abstractKeymap')
keymap.set('n', 'gitCommit', function ()
  local cwd = require('git-utils.git').top(require('arctgx.base').getBufferCwd())
  require('git-utils.commit')({gitDir = cwd})
end)
keymap.set('n', 'gitCommitAmend', function ()
  local cwd = require('git-utils.git').top(require('arctgx.base').getBufferCwd())
  require('git-utils.commit')({gitDir = cwd, amend = true})
end)

keymap.set('n', 'gitPush', function ()
  require 'git-utils.git'.pushToAllRemoteRepos(require('git-utils').currentBufferDirectory())
end)

require('arctgx.lazy').setupOnLoad('git-utils', function ()
  require('git-utils').setup({
    telescopeAttachMappings = function (_promptBufnr, map) return require('arctgx.telescope').defaultFileMappings(_promptBufnr, map) end,
    currentBufferDirectory = require('arctgx.base').getBufferCwd,
  })
end)

require('git-utils.createCommands')()

keymap.set('n', 'browseGitBranches', function ()
  require('telescope')
  require('git-utils').branches()
end)
