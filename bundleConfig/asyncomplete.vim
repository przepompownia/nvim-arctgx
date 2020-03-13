if executable('phpactor')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'phpactor',
        \ 'cmd': {server_info->['phpactor', 'language-server']},
        \ 'whitelist': ['php'],
        \ })
endif
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
