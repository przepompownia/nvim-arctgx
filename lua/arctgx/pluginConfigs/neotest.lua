local session = require('arctgx.session')
require('neotest').setup({
  adapters = {
    require('neotest-phpunit') {
      phpunit_cmd = function ()
        return 'vendor/bin/phpunit'
      end,
      dap = require('arctgx.dap.php').default,
      env = {
        XDEBUG_CONFIG = 'idekey=neotest',
      },
    },
  }
})

session.appendBeforeSaveHook('Close neotest windows', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'neotest-output-panel', 'neotest-summary'}, function (winId)
    vim.api.nvim_win_close(winId, false)
  end)
end)
