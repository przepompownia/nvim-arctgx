local osv = require('osv')
local api = vim.api

api.nvim_create_user_command('OSVLaunch', function()
  osv.launch {
    host = '127.0.0.1',
    port = 9004,
    log = '/tmp/osv.log',
  }
end, {nargs = 0})
