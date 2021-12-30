lua <<EOF
_G.arctgx_telescope_git_grep_operator = require('arctgx/telescope').git_grep_operator
_G.arctgx_telescope_rg_grep_operator = require('arctgx/telescope').rg_grep_operator
EOF

nnoremap <leader>q :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
vnoremap <leader>q :<c-u>call v:lua.arctgx_telescope_rg_grep_operator(visualmode())<cr>
nnoremap <leader>w :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
vnoremap <leader>w :<c-u>call v:lua.arctgx_telescope_git_grep_operator(visualmode())<cr>
nmap <Plug>(ide-grep-git) <Cmd>GGrep<CR>
nmap <Plug>(ide-grep-files) <Cmd>RGrep<CR>

command! -nargs=* GGrep lua require('arctgx/telescope').git_grep_operator(<q-args>)
command! -nargs=* RGrep lua require('arctgx/telescope').rg_grep_operator(<q-args>)
