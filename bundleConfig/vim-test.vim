let test#strategy = 'dispatch'
let test#php#phpunit#executable = 'phpunit'
autocmd FileType php nmap <buffer> <Leader>t :TestNearest<CR>
