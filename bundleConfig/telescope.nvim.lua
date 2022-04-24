local action_layout = require 'telescope.actions.layout'
local actions = require 'telescope.actions'
local base = require 'arctgx.base'
local gdiff = require 'arctgx.telescope.gdiff'
local git = require('arctgx.git')
local windows = require('arctgx.telescope.windows')
local api = vim.api
local arctgx = require('arctgx.telescope')
local builtin = require('telescope.builtin')
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

_G.arctgx_telescope_git_grep_operator = arctgx.git_grep_operator
_G.arctgx_telescope_rg_grep_operator = arctgx.rg_grep_operator
_G.arctgx_telescope_files_git_operator = arctgx.files_git_operator
_G.arctgx_telescope_files_all_operator = arctgx.files_all_operator

api.nvim_create_user_command('GGrep', function(opts) arctgx.gitGrep(opts.args, false, false) end, {nargs = '*'})
api.nvim_create_user_command('RGrep', function(opts) arctgx.rgGrep(opts.args, false, false) end, {nargs = '*'})
api.nvim_create_user_command(
  'GTDiff',
  function(opts)
    gdiff.run({
      args = opts.fargs,
      cwd = git.top(base.getBufferCwd()),
    })
  end,
  {
    nargs = '*',
    complete = vim.fn['arctgx#git#completion#completeGFDiff'],
  }
)
keymap.set('n', '<Plug>(ide-grep-git)', function() arctgx.gitGrep('', false, false) end)
keymap.set('n', '<Plug>(ide-grep-files)', function() arctgx.rgGrep('', false, false) end)
keymap.set('n', '<Plug>(ide-browse-files)', arctgx.filesAll)
keymap.set('n', '<Plug>(ide-browse-gfiles)', arctgx.filesGit)
keymap.set('n', '<Plug>(ide-browse-cmd-history)', builtin.command_history)
keymap.set('n', '<Plug>(ide-browse-history)', arctgx.oldfiles)
keymap.set('n', '<Plug>(ide-browse-buffers)', arctgx.buffers)
keymap.set('n', '<Plug>(ide-browse-windows)', windows.list)
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

vim.cmd([[
  nnoremap <Plug>(ide-grep-string-search-operator) :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
  nnoremap <Plug>(ide-git-string-search-operator) :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
  nmap <Plug>(ide-git-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_git_operator<CR>g@
  nmap <Plug>(ide-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_all_operator<CR>g@

  hi TelescopeCaret guifg=#a52626 gui=bold guibg=#8b8d8b
  hi TelescopeSelection guifg=#f4fff4 gui=bold guibg=#8b8d8b
]])
