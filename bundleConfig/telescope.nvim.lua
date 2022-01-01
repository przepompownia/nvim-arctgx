local builtin = require('telescope.builtin')
local actions = require 'telescope.actions'
local action_layout = require 'telescope.actions.layout'
local arctgx = require('arctgx.telescope')
local api = vim.api

require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.99, width = 0.99 },
    mappings = {
      i = {
        ['<C-p>'] = actions.cycle_history_next,
        ['<C-n>'] = actions.cycle_history_prev,
        ['<A-Up>'] = actions.preview_scrolling_up,
        ['<A-Down>'] = actions.preview_scrolling_down,
        ['<A-/>'] = action_layout.toggle_preview,
        ['<CR>'] = arctgx.customActions.tabDrop,
      },
    },
  },
}

_G.arctgx_telescope_git_grep_operator = arctgx.git_grep_operator
_G.arctgx_telescope_rg_grep_operator = arctgx.rg_grep_operator
_G.arctgx_telescope_files_git_operator = arctgx.files_git_operator
_G.arctgx_telescope_files_all_operator = arctgx.files_all_operator

api.nvim_add_user_command('GGrep', function(opts) arctgx.git_grep(opts.args, false, false) end, {nargs = '*'})
api.nvim_add_user_command('RGrep', function(opts) arctgx.rg_grep(opts.args, false, false) end, {nargs = '*'})
api.nvim_set_keymap('n', '<Plug>(ide-grep-git)', '', {callback = function() arctgx.git_grep('', false, false) end})
api.nvim_set_keymap('n', '<Plug>(ide-grep-files)', '', {callback = function() arctgx.rg_grep('', false, false) end})
api.nvim_set_keymap('n', '<Plug>(ide-browse-files)', '', {callback = function() arctgx.files_all() end})
api.nvim_set_keymap('n', '<Plug>(ide-browse-gfiles)', '', {callback = function() arctgx.files_git() end})
api.nvim_set_keymap('n', '<Plug>(ide-browse-cmd-history)', '', {callback = function() builtin.command_history() end})

vim.cmd([[
  nnoremap <leader>q :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
  vnoremap <leader>q :<c-u>call v:lua.arctgx_telescope_rg_grep_operator(visualmode())<cr>
  nnoremap <leader>w :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
  vnoremap <leader>w :<c-u>call v:lua.arctgx_telescope_git_grep_operator(visualmode())<cr>

  vmap <Plug>(ide-git-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_git_operator(visualmode())<CR>
  nmap <Plug>(ide-git-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_git_operator<CR>g@

  vmap <Plug>(ide-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_all_operator(visualmode())<CR>
  nmap <Plug>(ide-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_all_operator<CR>g@
]])
