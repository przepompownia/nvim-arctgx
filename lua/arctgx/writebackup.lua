local WriteBackup = {}

WriteBackup.save = function ()
  local backupFile = ('%s/%s.%d'):format(
    vim.g.arctgxBackupDir or '/tmp',
    vim.fn.expand('%:t'),
    math.random(0, 9999)
  )

  vim.cmd.write(backupFile)
end

return WriteBackup
