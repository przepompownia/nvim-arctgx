augroup previews
  autocmd!
  autocmd CompleteDone * pclose
  autocmd WinEnter * if &previewwindow && winnr() > 1 | wincmd L | vertical resize 40 | endif
augroup END
