local session = require('arctgx.session')
local keymap = require('arctgx.vim.abstractKeymap')
local neotest = require('neotest')
neotest.setup({
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

keymap.set({'n'}, 'testUIToggleSummary', neotest.summary.toggle, {})
keymap.set({'n'}, 'testUIToggleOutput', neotest.output_panel.toggle, {})
keymap.set({'n'}, 'testUIRunNearest', neotest.run.run, {})
keymap.set({'n'}, 'testUIRunNearestWithDap', function () neotest.run.run({
  strategy = 'dap',
  -- env = phpXdebugEnv,
}) end, {})

session.appendBeforeSaveHook('Close neotest windows', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'neotest-output-panel', 'neotest-summary'}, function (winId)
    vim.api.nvim_win_close(winId, false)
  end)
end)
