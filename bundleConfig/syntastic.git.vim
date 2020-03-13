" let g:syntastic_dbug = 3
let g:syntastic_mode_map = {
  \ 'mode': 'passive',
  \ 'active_filetypes': ['php', 'sh']
  \}
let g:syntastic_sh_shellcheck_args = '--shell=bash'
let g:syntastic_sh_checkers=['bash', 'shellcheck']
" let g:syntastic_debug=33
let g:syntastic_auto_loc_list = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_php_checkers = ['php', 'phpstan', 'phpcs', 'phpmd']
" let g:syntastic_phpcs_disable = 1
" let g:syntastic_phpmd_disable = 1
" sprawdzić zastąpienie nazwy standardu ścieżką do pliku XML z definicją standardu
let g:syntastic_php_phpcs_args="--standard=psr2"
let g:syntastic_check_on_open = 1
