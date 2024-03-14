vim.api.nvim_create_user_command('ServerMakeDefault', function ()
  vim.fn.writefile({vim.v.servername}, '/tmp/nvim-default-socket')
end, {})
