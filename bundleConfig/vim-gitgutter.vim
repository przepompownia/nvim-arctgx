function s:loadCustomHighlight() abort
  if $TERM =~# '-256color$'
    highlight GitGutterAdd guifg=#51983c
    highlight GitGutterDelete guifg=#cc3b3b
    highlight GitGutterChange guifg=#d89b0b
    highlight GitGutterChangeDelete guifg=#a7680b
  endif
endfunction

augroup vimGitgutterCustom
  autocmd!
  autocmd VimEnter * call s:loadCustomHighlight()
augroup END

nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
nmap <Leader>ht :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_log = 0
let g:gitgutter_preview_win_floating = 1
