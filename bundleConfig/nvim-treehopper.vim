highlight TSNodeKey guifg=#a52626 gui=bold ctermfg=198 cterm=bold guibg=#c3c3c3

omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
vnoremap <silent> m :lua require('tsht').nodes()<CR>
