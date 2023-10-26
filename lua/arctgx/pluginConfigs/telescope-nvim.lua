local base = require 'arctgx.base'
local api = vim.api

require('telescope').setup {
  defaults = {
    preview = {
      timeout = 10,
    },
    layout_strategy = 'horizontal',
    layout_config = {
      height = 0.99,
      width = 0.99,
      preview_cutoff = 1,
    },
    mappings = {
      i = {
        ['<C-p>'] = 'cycle_history_next',
        ['<C-n>'] = 'cycle_history_prev',
        ['<A-Up>'] = 'preview_scrolling_up',
        ['<A-Down>'] = 'preview_scrolling_down',
        ['<A-/>'] = require 'telescope.actions.layout'.toggle_preview,
        ['<Esc>'] = 'close',
      },
    },
  },
}

api.nvim_create_user_command(
  'GGrep',
  function(opts) require('arctgx.telescope').gitGrep(opts.args, false, false) end,
  {nargs = '*'}
)
api.nvim_create_user_command(
  'RGrep',
  function(opts) require('arctgx.telescope').rgGrep(opts.args, false, false) end,
  {nargs = '*'}
)
api.nvim_create_user_command(
  'GTDiff',
  function (opts)
    require('arctgx.telescope.gdiff').run({
      args = opts.fargs,
      cwd = require('arctgx.git').top(base.getBufferCwd()),
    })
  end,
  {
    nargs = '*',
    complete = function (argLead, _, _)
      local git = require('arctgx.git')
      return git.matchBranchesToRange(git.top(base.getBufferCwd()), argLead)
    end,
  }
)
vim.keymap.set('n', '<Plug>(ide-grep-git)', function () require('arctgx.telescope').gitGrep('', false, false) end)
vim.keymap.set('n', '<Plug>(ide-grep-files)', function () require('arctgx.telescope').rgGrep('', false, false) end)
vim.keymap.set('n', '<Plug>(ide-browse-files)', function () require('arctgx.telescope').filesAll() end)
vim.keymap.set('n', '<Plug>(ide-browse-gfiles)', function () require('arctgx.telescope').filesGit() end)
vim.keymap.set('n', '<Plug>(ide-browse-cmd-history)', function () require('telescope.builtin').command_history() end)
vim.keymap.set('n', '<Plug>(ide-browse-history)', function () require('arctgx.telescope').oldfiles(false) end)
vim.keymap.set('n', '<Plug>(ide-browse-history-in-cwd)', function () require('arctgx.telescope').oldfiles(true) end)
vim.keymap.set('n', '<Plug>(ide-browse-buffers)', function () require('arctgx.telescope').buffers() end)
vim.keymap.set('n', '<Plug>(ide-browse-windows)', function () require('arctgx.telescope.windows').list() end)
vim.keymap.set('n', '<Plug>(ide-git-show-branches)', function () require('arctgx.telescope').branches() end)
vim.keymap.set('v', '<Plug>(ide-git-string-search-operator)', function ()
  require('arctgx.telescope').gitGrep(base.getVisualSelection(), true)
end)
vim.keymap.set('v', '<Plug>(ide-grep-string-search-operator)', function ()
  require('arctgx.telescope').rgGrep(base.getVisualSelection(), true)
end)
vim.keymap.set('v', '<Plug>(ide-git-files-search-operator)', function ()
  require('arctgx.telescope').filesGit(base.getVisualSelection())
end)
vim.keymap.set('v', '<Plug>(ide-files-search-operator)', function ()
  require('arctgx.telescope').filesAll(base.getVisualSelection())
end)

vim.keymap.set('n', '<Plug>(ide-git-string-search-operator)', function ()
  base.setOperatorfunc(require('arctgx.telescope').gitGrepOperator)
  return 'g@'
end, {expr = true})
vim.keymap.set('n', '<Plug>(ide-grep-string-search-operator)', function ()
  base.setOperatorfunc(require('arctgx.telescope').rgGrepOperator)
  return 'g@'
end, {expr = true})
vim.keymap.set('n', '<Plug>(ide-git-files-search-operator)', function ()
  base.setOperatorfunc(require('arctgx.telescope').filesGitOperator)
  return 'g@'
end, {expr = true})
vim.keymap.set('n', '<Plug>(ide-files-search-operator)', function ()
  base.setOperatorfunc(require('arctgx.telescope').filesAllOperator)
  return 'g@'
end, {expr = true})
local augroup = api.nvim_create_augroup('ArctgxTelescope', {clear = true})
api.nvim_create_autocmd({'FileType'}, {
  group = augroup,
  callback = function ()
    vim.keymap.set({'n'}, 'zf', require('telescope.builtin').quickfix, {buffer = true})
  end,
})
