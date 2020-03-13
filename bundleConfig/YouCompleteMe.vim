let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_show_diagnostics_ui = 0

" Zostawione do zmiany przy testach wpisów phpdoc
let g:ycm_complete_in_comments = 0
" Też do testów z wartością 1
let g:ycm_seed_identifiers_with_syntax = 0

let g:ycm_use_ultisnips_completer = 1

let g:ycm_semantic_triggers = get(g:, 'ycm_semantic_triggers', {})
let g:ycm_semantic_triggers.php = ['->', '::', '(', 'use ', 'namespace ', '\', 'extends', 'implements', '$']
" let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_min_num_identifier_candidate_chars=99
