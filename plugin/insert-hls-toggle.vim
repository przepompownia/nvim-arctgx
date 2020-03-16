augroup InsertHlsearchToggle
  autocmd!
  autocmd InsertEnter * let b:savedHlsearch = &hlsearch | let &hlsearch = 0
  autocmd InsertLeave * let &hlsearch = get(b:, 'savedHlsearch', 1)
augroup END
