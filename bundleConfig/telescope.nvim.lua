local actions = require 'telescope.actions'
local transform_mod = require('telescope.actions.mt').transform_mod
local action_set = require 'telescope.actions.set'
local action_layout = require 'telescope.actions.layout'
local arctgx = require('arctgx/telescope')

local customActions = transform_mod({
  tabDrop = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, 'TabDrop')
  end,
})

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-p>'] = actions.cycle_history_next,
        ['<C-n>'] = actions.cycle_history_prev,
        ['<A-Up>'] = actions.preview_scrolling_up,
        ['<A-Down>'] = actions.preview_scrolling_down,
        ['<A-/>'] = action_layout.toggle_preview,
        ['<CR>'] = customActions.tabDrop,
      },
    },
  },
}

_G.arctgx_telescope_git_grep_operator = arctgx.git_grep_operator
_G.arctgx_telescope_rg_grep_operator = arctgx.rg_grep_operator
_G.arctgx_telescope_files_git_operator = arctgx.files_git_operator
_G.arctgx_telescope_files_all_operator = arctgx.files_all_operator

vim.cmd([[
  nnoremap <leader>q :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
  vnoremap <leader>q :<c-u>call v:lua.arctgx_telescope_rg_grep_operator(visualmode())<cr>
  nnoremap <leader>w :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
  vnoremap <leader>w :<c-u>call v:lua.arctgx_telescope_git_grep_operator(visualmode())<cr>

  vmap <Plug>(ide-git-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_git_operator(visualmode())<CR>
  nmap <Plug>(ide-git-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_git_operator<CR>g@

  vmap <Plug>(ide-files-search-operator) :<C-U>call v:lua.arctgx_telescope_files_all_operator(visualmode())<CR>
  nmap <Plug>(ide-files-search-operator) :set operatorfunc=v:lua.arctgx_telescope_files_all_operator<CR>g@

  nmap <Plug>(ide-grep-git) <Cmd>GGrep<CR>
  nmap <Plug>(ide-grep-files) <Cmd>RGrep<CR>

  command! -nargs=* GGrep lua require('arctgx/telescope').git_grep(<q-args>, false, false)
  command! -nargs=* RGrep lua require('arctgx/telescope').rg_grep(<q-args>, false, false)

  nmap <Plug>(ide-browse-files) <Cmd>lua require('arctgx/telescope').files_all()<CR>
  nmap <Plug>(ide-browse-gfiles) <Cmd>lua require('arctgx/telescope').files_git()<CR>
]])

