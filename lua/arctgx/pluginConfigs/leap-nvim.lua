vim.keymap.set('n', 'gs', function ()
  require('leap').leap {
    windows = {vim.api.nvim_get_current_win()},
    inclusive = true
  }
end)
vim.keymap.set('n', 'S', function ()
  require('leap').leap {
    windows = require('leap.user').get_enterable_windows()
  }
end)
vim.keymap.set({'x', 'o'}, 'gs', function () require('leap').leap {inclusive = true} end)
vim.keymap.set({'x', 'o'}, 'S', function () require('leap').leap {backward = true} end)
require('arctgx.lazy').setupOnLoad('leap', {
  before = function () vim.cmd.packadd('leap.nvim') end,
  after = function ()
  end
})
