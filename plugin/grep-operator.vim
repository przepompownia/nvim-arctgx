lua <<EOF
_G.arctgx_telescope_git_grep_operator = require('arctgx/telescope').git_grep_operator
_G.arctgx_telescope_rg_grep_operator = require('arctgx/telescope').rg_grep_operator
EOF

nnoremap <leader>q :set operatorfunc=v:lua.arctgx_telescope_rg_grep_operator<cr>g@
vnoremap <leader>q :<c-u>call v:lua.arctgx_telescope_rg_grep_operator(visualmode())<cr>
nnoremap <leader>w :set operatorfunc=v:lua.arctgx_telescope_git_grep_operator<cr>g@
vnoremap <leader>w :<c-u>call v:lua.arctgx_telescope_git_grep_operator(visualmode())<cr>
nmap <Plug>(ide-grep-git) <Cmd>GGrep!<CR>
nmap <Plug>(ide-grep-files) <Cmd>RGrep!<CR>

command! -bang -nargs=* GGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getGitGrepCmd'),
      \ arctgx#git#getWorkspaceRoot(arctgx#base#getBufferDirectory()),
      \ <q-args>,
      \ v:false,
      \ v:false,
      \ <bang>0,
      \ )
command! -bang -nargs=* RGrep call arctgx#grep#grep(
      \ function('arctgx#grep#getRipGrepCmd'),
      \ getcwd(),
      \ <q-args>,
      \ v:false,
      \ v:false,
      \ <bang>0
      \ )
