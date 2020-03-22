let test#strategy = 'dispatch'
let test#php#phpunit#executable = 'phpunit'
augroup VimTest
  autocmd!
  autocmd FileType php nmap <buffer> <Leader>t :TestNearest<CR>
augroup end
