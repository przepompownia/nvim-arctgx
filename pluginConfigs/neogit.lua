local base = require('arctgx.base')
local neogit = require('neogit')

neogit.setup {
  disable_builtin_notifications = true,
  disable_commit_confirmation = true,
}

local function getTopDir()
  return require('arctgx.git').top(base.getBufferCwd())
end

vim.keymap.set('n', '<Plug>(ide-git-status)', function ()
  neogit.open({ cwd = getTopDir() })
end)
vim.keymap.set('n', '<Plug>(ide-git-commit)', function ()
  neogit.open({ 'commit', cwd = getTopDir()})
end)
