local session = require('arctgx.session')
local keymap = require('arctgx.vim.abstractKeymap')
require('arctgx.lazy').setupOnLoad('neotest', {
  before = function () vim.cmd.packadd('neotest') end,
  after = function ()
    require('neotest').setup({
      -- log_level = vim.log.levels.INFO,
      adapters = {
        require('neotest-phpunit') {
          filter_dirs = {
            'vendor',
          },
          phpunit_cmd = function ()
            return 'vendor/bin/phpunit'
          end,
          dap = require('arctgx.dap.php').default,
          env = {
            XDEBUG_CONFIG = 'idekey=neotest',
            -- XDEBUG_TRIGGER = '1',
          },
        },
      }
    })
  end
})

keymap.set({'n'}, 'testUIToggleSummary', function () require('neotest').summary.toggle() end, {})
keymap.set({'n'}, 'testUIToggleOutput', function () require('neotest').output_panel.toggle() end, {})
keymap.set({'n'}, 'testUIRunNearest', function () require('neotest').run.run() end, {})
keymap.set({'n'}, 'testUIRunNearestWithDap', function ()
  require('neotest').run.run({
    strategy = 'dap',
    -- env = phpXdebugEnv,
  })
end, {})

session.appendBeforeSaveHook('Close neotest windows', function ()
  require('arctgx.window').forEachWindowWithBufFileType({'neotest-output-panel', 'neotest-summary'}, function (winId)
    vim.api.nvim_win_close(winId, false)
  end)
end)
