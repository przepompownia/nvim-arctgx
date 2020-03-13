finish
autocmd FileType php setlocal omnifunc=lsp#complete
let g:lsp_log_file = expand('~/.vim-lsp.log')
au User lsp_setup call lsp#register_server({
      \ 'name': 'php-language-server',
      \ 'cmd': {server_info->['php', exepath('php-language-server.php')]},
      \ 'whitelist': ['php'],
      \ })
