local keymap = require('arctgx.vim.abstractKeymap')
vim.g.arctgxBackupDir = vim.fs.joinpath(vim.env['XDG_CONFIG_HOME'] or os.getenv('HOME'), '.config', 'backups')
keymap.set('n', 'writeBackup', function ()
  require('arctgx.writebackup').save()
end)

keymap.set('n', 'langIncrementSelection', function () require('arctgx.treesitter.incremental-selection').selectNodeUnderCursor() end)
keymap.set('v', 'langIncrementSelection', function () require('arctgx.treesitter.incremental-selection').incrementSelection() end)
keymap.set('v', 'langDecrementSelection', function () require('arctgx.treesitter.incremental-selection').decrementSelection() end)
