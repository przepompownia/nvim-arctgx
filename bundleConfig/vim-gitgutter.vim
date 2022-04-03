function! s:loadCustomHighlight() abort
  if $TERM !~# '-256color$' && &termguicolors == 0
    return
  endif
  highlight! link GitGutterAdd IdeGutterAdd
  highlight! link GitGutterDelete IdeGutterDelete
  highlight! link GitGutterChange IdeGutterChange
  highlight! link GitGutterChangeDelete IdeGutterChangeDelete
endfunction

augroup vimGitgutterCustom
  autocmd!
  autocmd ColorScheme * call s:loadCustomHighlight()
augroup END

nmap <Plug>(ide-git-hunk-previous) <Plug>(GitGutterPrevHunk)
nmap <Plug>(ide-git-hunk-next) <Plug>(GitGutterNextHunk)
nmap <Plug>(ide-git-hunk-print) <Plug>(GitGutterPreviewHunk)
nmap <Plug>(ide-git-hunk-stage) <Plug>(GitGutterStageHunk)
nmap <Plug>(ide-git-hunk-reset) <Plug>(GitGutterUndoHunk)
nmap <Plug>(ide-git-highlight-toggle) :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_log = 0
let g:gitgutter_preview_win_floating = 1
