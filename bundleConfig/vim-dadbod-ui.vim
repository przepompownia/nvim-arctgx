let g:db_ui_table_helpers = {
      \ 'mysql': {
      \ 	'Get By ID': 'SELECT * FROM {optional_schema}{table} WHERE `id` = :{table}_id \G',
      \ 	'Explain': 'ANALYZE {last_query}',
      \     'Show create table': 'SHOW CREATE TABLE {optional_schema}{table}'
      \ }
      \ }
let g:db_ui_force_echo_notifications = 1

function s:bufferNameGenerator(opts) abort
  let l:time = strftime('%Y-%m-%d-%T')

  let l:table = has_key(a:opts, 'table') ? ('-' . a:opts.table) : ''

  return printf('%s%s.%s', l:time, l:table, a:opts.filetype)
endfunction

let g:Db_ui_buffer_name_generator = function('s:bufferNameGenerator')

augroup DBUISettings
  autocmd!

  autocmd FileType dbui
        \ let b:ideTabName = 'DBUI[d]' |
        \ call s:loadMappings()
  " fix for non-dbui sql buffers
  autocmd FileType dbui,dbout,sql nmap <Leader>n <Plug>(dbui-new-query)
  autocmd FileType sql |
        \ if exists('b:dbui_db_key_name') |
        \ let b:ideTabName = 'DBUI[q]' |
        \ endif
  autocmd FileType mysql let b:ideTabName = 'DBUI[q]'
  autocmd FileType dbout let b:ideTabName = 'DBUI[o]'
augroup end

function! s:loadMappings() abort
  nmap <buffer> <Left> <Plug>(DBUI_GotoParentNode)<CR>
  nmap <buffer> <Right> <Plug>(DBUI_GotoChildNode)
endfunction

nmap <Plug>(dbui-new-query) <Cmd>call <SID>openNewQuery()<CR>
function! s:openNewQuery() abort
  DBUI
  execute "/New query"
  exe "normal \<Plug>(DBUI_SelectLine)"
endfunction
