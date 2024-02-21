local keymap = require('arctgx.vim.abstractKeymap')
vim.g.arctgxBackupDir = vim.env['XDG_CONFIG_HOME'] or vim.env['HOME'] .. '/.config/backups'
keymap.set('n', 'writeBackup', function ()
  require('arctgx.writebackup').save()
end)
