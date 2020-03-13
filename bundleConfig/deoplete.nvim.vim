let g:deoplete#enable_at_startup = 0
call deoplete#custom#source('_', 'converters', ['converter_auto_paren'])
augroup deoplete
  autocmd!
  autocmd InsertEnter * call deoplete#enable()
augroup END

call deoplete#custom#option({
\ 'camel_case': v:true,
\ })

call deoplete#custom#source('omni', 'functions', {
      \ 'php': 'phpactor#Complete'
      \ })

" call deoplete#custom#var('omni', 'input_patterns', {
      " \ 'php': '\w+|->\w*|\w+::\w*',
" \ })

call deoplete#custom#source('_', 'matchers', ['matcher_head'])
call deoplete#custom#source('_', 'sorters', ['sorter_word'])
" call deoplete#custom#source('ultisnips', 'rank', 9999)
" variable first
