let g:test#strategy = 'dispatch'
function s:xdebugWrapper(cmd) abort
  return '-compiler=phpunit XDEBUG_CONFIG="vim" php -dzend_extension=xdebug.so '. a:cmd
endfunction
" let g:test#php#phpunit#executable = ''
" let g:test#php#phpunit#options = ''
let g:test#custom_transformations = {'xdebug': function('s:xdebugWrapper')}
" Set in local .exrc
" let g:test#transformation = 'xdebug'
augroup VimTest
  autocmd!
  autocmd FileType php nmap <buffer> <Leader>t :TestNearest<CR>
augroup end
