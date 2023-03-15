local base = require('arctgx.base')

vim.keymap.set('n', '<Plug>(ide-url-open-operator)', function ()
  base.runOperator("v:lua.require'arctgx.url'.openWithOperator")
end)
vim.keymap.set('v', '<Plug>(ide-url-open-operator)', function ()
  require('arctgx.url').open(base.getVisualSelection())
end)
