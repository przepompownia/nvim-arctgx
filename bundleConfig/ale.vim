let g:ale_php_phpcs_standard='PSR12'
let g:ale_php_phpstan_level = 'max'
" let g:ale_php_langserver_executable = exepath('php-language-server.php')
let g:ale_sh_shellcheck_dialect = 'bash'
let g:ale_sh_shfmt_options = '-i 4'
let g:ale_echo_msg_format = '[%linter%]: [%code%] %s [%severity%]'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
" let g:ale_php_cs_fixer_use_global = 1
" let g:ale_php_cs_fixer_options = ''
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0
let g:ale_disable_lsp = 1
let g:ale_hover_cursor = 0
let g:ale_linters = {
      \   'sh': ['shell'],
      \   'typescript': ['eslint', 'tslint', 'typecheck', 'xo'],
      \   'php': ['langserver', 'phan', 'php', 'psalm']
      \}
