let g:airline_symbols = get(g:, 'airline_symbols', {})
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled=0
let g:airline#extensions#tabline#show_buffers=0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#ale#enabled = 0
" ro=⊝, ws=☲, lnr=☰, mlnr=㏑, br=ᚠ, nx=Ɇ, crypt=🔒
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.whitespace = ''
let g:airline_symbols.notexists = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.crypt = ''
let g:airline_symbols.spell = ''
" let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_section_a = 'b:%n, tw:%{tabpagenr()}.%{winnr()} (%{win_getid()}) %#__accent_bold#%{winnr()==winnr("#")?" [LW]":""}%#__restore__#'
" let g:airline_section_c = '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
" let g:airline_inactive_collapse=0
let g:airline#init#vim_async = 1
let g:airline#extensions#branch#format = 'arctgx#string#shorten'
let g:airline_inactive_collapse=0
