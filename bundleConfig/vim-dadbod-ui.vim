let g:db_ui_table_helpers = {
      \ 'mysql': {
      \ 	'Get By ID': 'SELECT * FROM {optional_schema}{table} WHERE `id` = :{table}_id \G',
      \ 	'Explain': 'EXPLAIN ANALYZE {last_query}',
      \     'Show create table': 'SHOW CREATE TABLE {optional_schema}{table}'
      \ }
      \ }
let g:db_ui_force_echo_notifications = 1

augroup DBUISettings
  autocmd!

  autocmd FileType dbui let b:ideTabName = 'DBUI[d]'
  " fix for non-dbui sql buffers
  autocmd FileType sql let b:ideTabName = 'DBUI[q]'
  autocmd FileType dbout let b:ideTabName = 'DBUI[o]'
augroup end
