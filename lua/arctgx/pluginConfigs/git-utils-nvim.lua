local keymap = require('arctgx.vim.abstractKeymap')
keymap.set('n', 'gitCommit', function ()
  local cwd = require('git-utils.git').top(require('arctgx.base').getBufferCwd())
  require('git-utils.commit')({gitDir = cwd})
end)

keymap.set('n', 'gitPush', function ()
  require 'git-utils.git'.pushToAllRemoteRepos(require('git-utils').currentBufferDirectory())
end)

require('arctgx.lazy').setupOnLoad('git-utils', function ()
  require('git-utils').setup({
    createCommands = true,
    telescopeAttachMappings = function () require('arctgx.telescope').defaultFileMappings() end,
    currentBufferDirectory = require('arctgx.base').getBufferCwd,
  })
end)

keymap.set('n', 'browseGitBranches', function ()
  require('telescope')
  require('git-utils').branches()
end)
