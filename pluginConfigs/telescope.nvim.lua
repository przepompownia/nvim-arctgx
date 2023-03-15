local action_layout = require 'telescope.actions.layout'
local actions = require 'telescope.actions'
local base = require 'arctgx.base'
local api = vim.api
local arctgx = require('arctgx.telescope')
local keymap = require('vim.keymap')

require('telescope').setup {
  defaults = {
    previewer = true,
    preview_cutoff = 1,
    layout_strategy = 'horizontal',
    layout_config = {height = 0.99, width = 0.99},
    -- borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
    mappings = {
      i = {
        ['<C-p>'] = actions.cycle_history_next,
        ['<C-n>'] = actions.cycle_history_prev,
        ['<A-Up>'] = actions.preview_scrolling_up,
        ['<A-Down>'] = actions.preview_scrolling_down,
        ['<A-/>'] = action_layout.toggle_preview,
        ['<Esc>'] = actions.close,
      },
    },
  },
}

api.nvim_create_user_command('GGrep', function(opts) arctgx.gitGrep(opts.args, false, false) end, {nargs = '*'})
api.nvim_create_user_command('RGrep', function(opts) arctgx.rgGrep(opts.args, false, false) end, {nargs = '*'})
api.nvim_create_user_command(
  'GTDiff',
  function(opts)
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
keymap.set('n', '<Plug>(ide-grep-git)', function() arctgx.gitGrep('', false, false) end)
keymap.set('n', '<Plug>(ide-grep-files)', function() arctgx.rgGrep('', false, false) end)
keymap.set('n', '<Plug>(ide-browse-files)', arctgx.filesAll)
keymap.set('n', '<Plug>(ide-browse-gfiles)', arctgx.filesGit)
keymap.set('n', '<Plug>(ide-browse-cmd-history)', function() require('telescope.builtin').command_history() end)
keymap.set('n', '<Plug>(ide-browse-history)', function() arctgx.oldfiles(false) end)
keymap.set('n', '<Plug>(ide-browse-history-in-cwd)', function() arctgx.oldfiles(true) end)
keymap.set('n', '<Plug>(ide-browse-buffers)', arctgx.buffers)
keymap.set('n', '<Plug>(ide-browse-windows)', function() require('arctgx.telescope.windows').list() end)
keymap.set('n', '<Plug>(ide-git-show-branches)', arctgx.branches)
keymap.set('v', '<Plug>(ide-git-string-search-operator)', function()
  arctgx.gitGrep(base.getVisualSelection(), true)
end)
keymap.set('v', '<Plug>(ide-grep-string-search-operator)', function()
  arctgx.rgGrep(base.getVisualSelection(), true)
end)
keymap.set('v', '<Plug>(ide-git-files-search-operator)', function()
  arctgx.filesGit(base.getVisualSelection(), true)
end)
keymap.set('v', '<Plug>(ide-files-search-operator)', function()
  arctgx.filesAll(base.getVisualSelection(), true)
end)

keymap.set('n', '<Plug>(ide-git-string-search-operator)', function ()
  base.runOperator("v:lua.require'arctgx.telescope'.git_grep_operator")
end)
keymap.set('n', '<Plug>(ide-grep-string-search-operator)', function ()
  base.runOperator("v:lua.require'arctgx.telescope'.rg_grep_operator")
end)
keymap.set('n', '<Plug>(ide-git-files-search-operator)', function ()
  base.runOperator("v:lua.require'arctgx.telescope'.files_git_operator")
end)
keymap.set('n', '<Plug>(ide-files-search-operator)', function ()
  base.runOperator("v:lua.require'arctgx.telescope'.files_all_operator")
end)
local function reloadColors()
  api.nvim_set_hl(0, 'TelescopeCaret', {fg = '#a52626', bg = '#8b8d8b', bold = true, default = false})
  api.nvim_set_hl(0, 'TelescopeSelection', {fg = '#f4fff4', bg = '#8b8d8b', bold = true, default = false})
end
local augroup = api.nvim_create_augroup('ArctgxTelescope', { clear = true })
api.nvim_create_autocmd({'ColorScheme'}, {
  group = augroup,
  callback = reloadColors,
})
