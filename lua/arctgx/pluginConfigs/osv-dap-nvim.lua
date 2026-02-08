require('arctgx.lazy').setupOnLoad('osv', {
  before = function () vim.cmd.packadd('osv-dap-nvim') end,
})
vim.api.nvim_create_user_command('OSVLaunch', function ()
  require('osv').launch {
    host = '127.0.0.1',
    port = 9004,
    log = '/tmp/osv.log',
  }
end, {nargs = 0})
