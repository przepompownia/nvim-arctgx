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
