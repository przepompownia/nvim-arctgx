local keymap = require('arctgx.vim.abstractKeymap')
vim.g.arctgxBackupDir = vim.env['XDG_CONFIG_HOME'] or vim.env['HOME'] .. '/.config/backups'
keymap.set('n', 'writeBackup', function ()
  require('arctgx.writebackup').save()
end)
keymap.set('n', 'gitPush', function ()
  require 'arctgx.git'.pushToAllRemoteRepos(require('arctgx.base').getBufferCwd())
end)
keymap.set('n', 'gitCommit', function ()
  require 'arctgx.shell'.open({
    cmd = {'git', 'commit'},
    cwd = require('arctgx.git').top(require('arctgx.base').getBufferCwd()),
  })
end)
