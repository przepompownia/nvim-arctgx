require('arctgx.lazy').setupOnLoad('neotest', {
  before = function ()
    vim.cmd.packadd('neotest-phpunit')
  end,
})
