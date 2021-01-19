let g:db_ui_table_helpers = {
      \ 'mysql': {
      \ 	'Get By ID': 'SELECT * FROM {optional_schema}{table} WHERE `id` = :{table}_id \G',
      \ 	'Explain': 'EXPLAIN ANALYZE {last_query}',
      \     'Show create table': 'SHOW CREATE TABLE {optional_schema}{table}'
      \ }
      \ }
