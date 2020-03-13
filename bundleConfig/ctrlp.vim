let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_user_command = {
      \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files'],
      \ },
      \ 'fallback': 'find %s -type f'
      \ }
let g:ctrlp_open_multiple_files = 'tj'
