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

nmap <Plug>(ide-git-hunk-previous) <Plug>(GitGutterPrevHunk)
nmap <Plug>(ide-git-hunk-next) <Plug>(GitGutterNextHunk)
nmap <Plug>(ide-git-hunk-print) <Plug>(GitGutterPreviewHunk)
nmap <Plug>(ide-git-hunk-stage) <Plug>(GitGutterStageHunk)
nmap <Plug>(ide-git-hunk-undo) <Plug>(GitGutterUndoHunk)
nmap <Leader>ht :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_log = 0
let g:gitgutter_preview_win_floating = 1
