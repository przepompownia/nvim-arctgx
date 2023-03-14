vim.g.arctgxBackupDir = vim.env['XDG_CONFIG_HOME'] .. '/.config/backups'
vim.keymap.set('n', '<Plug>(ide-write-backup)', require('arctgx.writebackup').save)
vim.keymap.set('n', '<Plug>(ide-git-push-all)', function ()
  require'arctgx.git'.pushToAllRemoteRepos(require('arctgx.base').getBufferCwd())
end)
