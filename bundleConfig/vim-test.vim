let g:test#strategy = 'dispatch'
let g:test#php#phpunit#executable = 'phpunit'
augroup VimTest
  autocmd!
  autocmd FileType php nmap <buffer> <Leader>t :TestNearest<CR>
augroup end
