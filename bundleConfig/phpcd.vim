let g:phpcd_server_options = get(g:, 'phpcd_server_options', {})
let g:phpcd_server_options.completion_match_type = 'head_or_subsequence_of_last_part'
let g:phpcd_insert_class_shortname = 1
let g:phpcd_server_options.logger_implementation = '\PHPCD\Log\DateTimeLogger'
