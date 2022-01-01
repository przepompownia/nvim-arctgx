local builtin = require('telescope.builtin')
local actions = require 'telescope.actions'
local action_layout = require 'telescope.actions.layout'
local arctgx = require('arctgx.telescope')
local api = vim.api

require('telescope').setup {
  defaults = {
    previewer = true,
    preview_cutoff = 1,
    layout_strategy = 'vertical',
    layout_config = { height = 0.99, width = 0.99 },
    mappings = {
      i = {
        ['<C-p>'] = actions.cycle_history_next,
        ['<C-n>'] = actions.cycle_history_prev,
        ['<A-Up>'] = actions.preview_scrolling_up,
        ['<A-Down>'] = actions.preview_scrolling_down,
        ['<A-/>'] = action_layout.toggle_preview,
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
api.nvim_set_keymap('n', '<Plug>(ide-browse-history)', '', {callback = function() builtin.oldfiles() end})

vim.cmd([[
  nnoremap <leader>q :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
  vnoremap <leader>q :<c-u>call v:lua.arctgx_telescope_rg_grep_operator(visualmode())<cr>
  nnoremap <leader>w :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
  vnoremap <leader>w :<c-u>call v:lua.arctgx_telescope_git_grep_operator(visualmode())<cr>

  vmap <Plug>(ide-git-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_git_operator(visualmode())<CR>
  nmap <Plug>(ide-git-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_git_operator<CR>g@

  vmap <Plug>(ide-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_all_operator(visualmode())<CR>
  nmap <Plug>(ide-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_all_operator<CR>g@

  " nmap <Plug>(ide-browse-buffers) <Cmd>call fzf#vim#buffers({}, 0)<CR>
  " nmap <Plug>(ide-browse-windows) <Cmd>call fzf#vim#windows()<CR>
]])

-- lua require('telescope.builtin').find_files({layout_strategy='vertical',layout_config={width=0.99, preview_cutoff=40}, find_command={'git', 'ls-files'}}).get_dropdown({previewer = true})
-- lua require('telescope.builtin').live_grep({cwd = require('telescope.utils').buffer_dir(), default_text = 'ta'})
-- lua require('telescope.builtin').live_grep({cwd = require('telescope.utils').buffer_dir(), default_text = 'ta', grep_open_files = false, vimgrep_arguments = {'git', 'grep', '--fixed-strings', '--color=never', '--line-number', '--column'} })
-- lua require('telescope.builtin').live_grep({cwd = require('telescope.utils').buffer_dir(), default_text = 'ta', grep_open_files = false, vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' } })
-- { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }
-- lua require('telescope.builtin').live_grep({cwd = require('telescope.utils').buffer_dir(), default_text = 'ta', grep_open_files = false, vimgrep_arguments = {'git', 'grep', '--fixed-strings', '--color=never', '--line-number', '--column'}, layout_strategy='vertical',layout_config={width=0.99, preview_cutoff=40} })
--
