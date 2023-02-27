local base = require('arctgx.base')
local neogit = require('neogit')

neogit.setup {}

vim.keymap.set('n', '<Plug>(ide-git-status)', function ()
  neogit.open({ cwd = base.getBufferCwd() })
end)
vim.keymap.set('n', '<Plug>(ide-git-commit)', function ()
  neogit.open({ 'commit', cwd = base.getBufferCwd()})
end)
vim.keymap.set('n', '<Plug>(ide-git-push-all)', function ()
  neogit.open({ 'push', cwd = base.getBufferCwd()})
end)
