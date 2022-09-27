augroup ideMaps
  autocmd!
  autocmd FileType * call s:defineIDEMaps() |
        \ call s:defineDebuggerMaps()
  autocmd User IDEDebuggerMapsNeeded call s:defineDebuggerMaps()
augroup END

function s:isExcludedFromIDEMapping(filetype)
  let l:excludedFiletypes = ['fern', 'help', 'man', 'dbout', 'dapui_hover', 'fugitive']

  return index(l:excludedFiletypes, a:filetype) >= 0
endfunction

function s:defineIDEMaps()
  if s:isExcludedFromIDEMapping(&filetype)
    return
  endif

  imap <buffer> <C-\>, <Plug>(ide-show-signature-help)
  nmap <buffer> <Leader>ish <Plug>(ide-show-signature-help)
  imap <buffer> <C-Space> <Plug>(ide-trigger-completion)
  nmap <buffer> <C-]> <Plug>(ide-goto-definition)
  nmap <buffer> gd <Plug>(ide-goto-definition)
  nmap <buffer> gyd <Plug>(ide-goto-definition-in-place)
  nmap <buffer> gD <Plug>(ide-peek-definition)
  nmap <buffer> <C-LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> g<LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>icn <Plug>(ide-class-new)
  nmap <buffer> gi <Plug>(ide-goto-implementation)
  nmap <buffer> gr <Plug>(ide-find-references)
  nmap <buffer> <Leader>] <Plug>(ide-find-references)
  nmap <buffer> <Leader>ih <Plug>(ide-hover)
  nmap <buffer> K <Plug>(ide-hover)
  nmap <buffer> <Leader>iaf <Plug>(ide-action-fold)
  nmap <buffer> <Leader>iar <Plug>(ide-action-rename)
  nmap <buffer> <Leader>ilo <Plug>(ide-list-document-symbols)
  nmap <buffer> <Leader>ilf <Plug>(ide-list-document-functions)
  nmap <buffer> <Leader>ilw <Plug>(ide-list-workspace-symbols)
  nmap <buffer> <Leader>irs <Plug>(ide-range-select)
  nmap <buffer> ]] <Plug>(ide-move-forward-function-start)
  nmap <buffer> ][ <Plug>(ide-move-forward-function-end)
  nmap <buffer> ]m <Plug>(ide-move-forward-class-start)
  nmap <buffer> ]M <Plug>(ide-move-forward-class-end)
  nmap <buffer> [[ <Plug>(ide-move-backward-function-start)
  nmap <buffer> [] <Plug>(ide-move-backward-function-end)
  nmap <buffer> [m <Plug>(ide-move-backward-class-start)
  nmap <buffer> [M <Plug>(ide-move-backward-class-end)
  xmap <buffer> if <Plug>(ide-select-function-inner)
  xmap <buffer> af <Plug>(ide-select-function-outer)
  nmap <buffer> <Leader>a <Plug>(ide-parameter-swap-forward)
  nmap <buffer> <Leader>A <Plug>(ide-parameter-swap-backward)
  xmap <buffer> ic <Plug>(ide-select-class-inner)
  omap <buffer> ic <Plug>(ide-select-class-inner)
  xmap <buffer> ac <Plug>(ide-select-class-outer)
  omap <buffer> ac <Plug>(ide-select-class-outer)
  nmap <buffer> <Leader>ii <Plug>(ide-diagnostic-info)
  nmap <buffer> <Leader>ca <Plug>(ide-codelens-action)

  nmap <buffer> <F6> <Plug>(ide-list-document-symbols)
  nmap <buffer> <Leader>dr <Plug>(ide-debugger-run)
  nmap <buffer> <Leader><S-F5> <Plug>(ide-debugger-ui-toggle)
  nmap <buffer> <Leader>dt <Plug>(ide-debugger-toggle-breakpoint)
  nmap <buffer> <Leader><S-F10> <Plug>(ide-debugger-toggle-breakpoint-conditional)
  nmap <buffer> <Leader>db <Plug>(ide-debugger-clear-breakpoints)
  nmap <buffer> gnj <Plug>(ide-revj-at-cursor)
endfunction

function s:defineDebuggerMaps() abort
  nmap <buffer> <Leader>dq <Plug>(ide-debugger-close)
  nmap <buffer> <Leader><S-F6> <Plug>(ide-debugger-detach)
  nmap <buffer> <Leader>di <Plug>(ide-debugger-step-into)
  nmap <buffer> <Leader>do <Plug>(ide-debugger-step-out)
  nmap <buffer> <Leader>ds <Plug>(ide-debugger-step-over)
  nmap <buffer> <Leader><F9> <Plug>(ide-debugger-run-to-cursor)
  nmap <buffer> <Leader><F12> <Plug>(ide-debugger-eval-under-cursor)
  nmap <buffer> <Leader><Leader>e <Plug>(ide-debugger-eval-visual)
  nmap <buffer> <Leader><Leader>p <Plug>(ide-debugger-eval-popup)
  xmap <buffer> <Leader><Leader>p <Plug>(ide-debugger-eval-popup)
  nmap <buffer> <Leader>dk <Plug>(ide-debugger-up-frame)
  nmap <buffer> <Leader>dj <Plug>(ide-debugger-down-frame)
  nmap <buffer> <Leader>dw <Plug>(ide-debugger-go-to-view)
  nmap <buffer> <Leader>dc <Plug>(ide-debugger-close-view)
endfunction

nmap <Leader>hs <Plug>(ide-git-hunk-stage)
nmap <Leader>g <Plug>(ide-git-status)
nmap <Leader>gc <Plug>(ide-git-commit)
nmap <Leader>gb <Plug>(ide-git-blame)
nmap <Leader>gs <Plug>(ide-git-status)
nmap <Leader>gl <Plug>(ide-git-log)
nmap <Leader>gp <Plug>(ide-git-push-all)
nmap <Leader>hu <Plug>(ide-git-hunk-undo-stage)
nmap <Leader>hr <Plug>(ide-git-hunk-reset)
nmap <Leader>hR <Plug>(ide-git-buffer-reset)
nmap <Leader>hp <Plug>(ide-git-hunk-print)
nmap <Leader>ht <Plug>(ide-git-highlight-toggle)
nmap <Leader>hT <Plug>(ide-git-toggle-deleted)
nmap <Leader>hb <Plug>(ide-git-blame-line)
nmap <Leader>hB <Plug>(ide-git-blame-toggle-virtual)
nmap <Leader>hd <Plug>(ide-git-diffthis)
nmap <Leader>hD <Plug>(ide-git-diffthis-previous)

nmap <Leader>fg <Plug>(ide-git-files-search-operator)
vmap <Leader>fg <Plug>(ide-git-files-search-operator)
vmap <Leader>q <Plug>(ide-grep-string-search-operator)
nmap <Leader>q <Plug>(ide-grep-string-search-operator)
vmap <Leader>w <Plug>(ide-git-string-search-operator)
nmap <Leader>w <Plug>(ide-git-string-search-operator)
nmap <S-F2> <Plug>(ide-git-stage-write-file)
imap <S-F2> <C-o><S-F2>
nmap [h <Plug>(ide-git-hunk-previous)
nmap ]h <Plug>(ide-git-hunk-next)

nmap <Leader>t <Plug>(treesitter-init-selection)
vmap <Leader>] <Plug>(treesitter-node-incremental)
vmap <Leader>[ <Plug>(treesitter-node-decremental)
vmap <Leader><Leader>] <Plug>(treesitter-scope-incremental)

nmap <Leader>ff <Plug>(ide-files-search-operator)
vmap <Leader>ff <Plug>(ide-files-search-operator)

nmap gx <Plug>(ide-url-open-operator)
vmap gx <Plug>(ide-url-open-operator)

nmap <Leader>ibb <Plug>(ide-browse-buffers)
nmap <S-F1> <Plug>(ide-browse-buffers)
imap <S-F1> <C-o><S-F1>
nmap <Leader>; <Plug>(ide-browse-cmd-history)
nmap <Leader>ibh <Plug>(ide-browse-history)
nmap <F4> <Plug>(ide-browse-history)
imap <F4> <C-o><F4>
nmap ,<F4> <Plug>(ide-browse-history-in-cwd)
imap ,<F4> <C-o><Plug>(ide-browse-history-in-cwd)
nmap <S-F4> <Plug>(ide-git-show-branches)
imap <S-F4> <C-o><S-F4>
nmap <F5> <Plug>(ide-db-ui-toggle)
nmap <Leader>ibf <Plug>(ide-browse-files)
nmap <Leader>ibg <Plug>(ide-browse-gfiles)
nmap <Leader>ibw <Plug>(ide-browse-windows)
nmap <F1> <Plug>(ide-browse-windows)
imap <F1> <C-o><F1>
imap <F11> <C-o><F11>
imap <F12> <C-o><F12>
nmap <F11> <Plug>(ide-browse-gfiles)
nmap <S-F11> <Plug>(ide-browse-files)
imap <S-F11> <C-o><S-F11>
nmap <F12> <Plug>(ide-grep-git)
nmap <S-F12> <Plug>(ide-grep-files)
imap <S-F12> <C-o><S-F12>

nmap <Leader>igg <Plug>(ide-grep-git)
nmap <Leader>igf <Plug>(ide-grep-files)
nmap <Leader>m <Plug>(ide-tree-focus-current-file)
nnoremap <Leader>iwb <Plug>(ide-write-backup)

nmap <Esc> <Plug>(ide-close-popup)

command! IDEMapsEdit call arctgx#arctgx#editIDEMaps()
command! IDEMapsReload call arctgx#arctgx#reloadIDEMaps()
