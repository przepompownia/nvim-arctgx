local action_layout = require 'telescope.actions.layout'
local actions = require 'telescope.actions'
local base = require 'arctgx.base'
local gdiff= require 'arctgx.telescope.gdiff'
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
    layout_config = { height = 0.99, width = 0.99 },
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

api.nvim_create_user_command('GGrep', function(opts) arctgx.git_grep(opts.args, false, false) end, {nargs = '*'})
api.nvim_create_user_command('RGrep', function(opts) arctgx.rg_grep(opts.args, false, false) end, {nargs = '*'})
api.nvim_create_user_command(
  'GTDiff',
  function(opts)
    gdiff.run({
      args = opts.fargs,
      cwd = git.top(vim.fn.expand('%:p:h')),
    })
  end,
  {nargs = '*'}
)
keymap.set('n', '<Plug>(ide-grep-git)', function() arctgx.git_grep('', false, false) end)
keymap.set('n', '<Plug>(ide-grep-files)', function() arctgx.rg_grep('', false, false) end)
keymap.set('n', '<Plug>(ide-browse-files)', arctgx.files_all)
keymap.set('n', '<Plug>(ide-browse-gfiles)', arctgx.files_git)
keymap.set('n', '<Plug>(ide-browse-cmd-history)', builtin.command_history)
keymap.set('n', '<Plug>(ide-browse-history)', arctgx.oldfiles)
keymap.set('n', '<Plug>(ide-browse-buffers)', arctgx.buffers)
keymap.set('n', '<Plug>(ide-browse-windows)', windows.list)

vim.cmd([[
  nnoremap <Plug>(ide-grep-string-search-operator) :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
  vnoremap <Plug>(ide-grep-string-search-operator) :<c-u>call v:lua.arctgx_telescope_rg_grep_operator(visualmode())<cr>
  nnoremap <Plug>(ide-git-string-search-operator) :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
  vnoremap <Plug>(ide-git-string-search-operator) :<c-u>call v:lua.arctgx_telescope_git_grep_operator(visualmode())<cr>

  vmap <Plug>(ide-git-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_git_operator(visualmode())<CR>
  nmap <Plug>(ide-git-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_git_operator<CR>g@

  vmap <Plug>(ide-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_all_operator(visualmode())<CR>
  nmap <Plug>(ide-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_all_operator<CR>g@
  hi TelescopeCaret guifg=#a52626 gui=bold guibg=#8b8d8b
  hi TelescopeSelection guifg=#f4fff4 gui=bold guibg=#8b8d8b
]])
