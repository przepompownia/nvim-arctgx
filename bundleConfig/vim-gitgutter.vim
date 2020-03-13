if $TERM =~ '-256color$'
  highlight GitGutterAdd ctermbg=254 ctermfg=34
  highlight GitGutterAdd guifg=#51983c guibg=#eeeeee
  highlight GitGutterDelete guifg=#cc3b3b guibg=#eeeeee
  highlight GitGutterChange guifg=#d89b0b guibg=#eeeeee
  highlight GitGutterChangeDelete guifg=#a7680b guibg=#eeeeee
endif
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
nmap <Leader>ht :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_log = 0
let g:gitgutter_preview_win_floating = 1
