setlocal nomod noma
setlocal nonumber
setlocal foldmethod=manual
augroup manpages
  autocmd filetype man nnoremap <buffer> q :quit<CR>
  autocmd filetype man vnoremap <buffer> q <C-c>:quit<CR>
  autocmd filetype man nnoremap <buffer> <space> <C-f>
augroup end
