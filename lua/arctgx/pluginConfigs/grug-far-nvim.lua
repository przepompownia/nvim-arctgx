require('arctgx.lazy').setupOnLoad('grug-far', {
  before = function ()
    vim.cmd.packadd('grug-far.nvim')
  end,
  after = function ()
    require('grug-far').setup({
    })
  end
})

local keymap = require('arctgx.vim.abstractKeymap')
keymap.set({'n', 'v'}, 'searchAndReplaceTool', function () require('grug-far').open() end, {})
