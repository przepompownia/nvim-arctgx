local writebackup = require 'arctgx.writebackup'

vim.g.arctgxBackupDir = vim.env['XDG_CONFIG_HOME'] .. '/.config/backups'
vim.keymap.set('n', '<Plug>(ide-write-backup)', writebackup.save)
