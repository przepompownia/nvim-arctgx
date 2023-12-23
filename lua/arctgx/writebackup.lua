local WriteBackup = {}

function WriteBackup.save()
  local backupDir = vim.g.arctgxBackupDir or '/tmp'
  local backupFile = ('%s/%s.%d'):format(
    backupDir,
    vim.fn.expand('%:t'),
    os.date('%s')
  )

  vim.fn.mkdir(backupDir, 'p')
  vim.cmd({cmd = 'write', args = {backupFile}})
end

return WriteBackup
