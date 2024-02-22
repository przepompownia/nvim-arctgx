local keymap = require('arctgx.vim.abstractKeymap')
keymap.set('n', 'gitCommit', function ()
  local cwd = require('git-utils.git').top(require('arctgx.base').getBufferCwd())
  require('git-utils.commit')({gitDir = cwd})
end)

keymap.set('n', 'gitPush', function ()
  require 'git-utils.git'.pushToAllRemoteRepos(require('git-utils').currentBufferDirectory())
end)

require('git-utils').setup({
  createCommands = true,
  telescopeAttachMappings = require('arctgx.telescope').defaultFileMappings,
  currentBufferDirectory = require('arctgx.base').getBufferCwd,
})

keymap.set('n', 'browseGitBranches', require('git-utils').branches)
