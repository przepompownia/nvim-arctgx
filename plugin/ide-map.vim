augroup ideMaps
  autocmd!
  autocmd FileType * call s:defineIDEMaps() |
        \ call s:defineDebuggerMaps()
  autocmd User IDEDebuggerMapsNeeded call s:defineDebuggerMaps()
augroup END

function s:isExcludedFromIDEMapping(filetype)
  let l:excludedFiletypes = ['fern', 'help', 'man', 'dbout', 'dapui_hover']

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
  nmap <buffer> <C-LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> g<LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>icn <Plug>(ide-class-new)
  nmap <buffer> <Leader>igd <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>igi <Plug>(ide-goto-implementation)
  nmap <buffer> gi <Plug>(ide-goto-implementation)
  nmap <buffer> <Leader>ifr <Plug>(ide-find-references)
  nmap <buffer> gr <Plug>(ide-find-references)
  nmap <buffer> <Leader>] <Plug>(ide-find-references)
  nmap <buffer> <Leader>inm <Plug>(ide-navigation-menu)
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
  nmap <buffer> <Leader>d <Plug>(ide-diagnostic-info)
  nmap <buffer> <Leader>ca <Plug>(ide-codelens-action)

  nmap <buffer> <Leader><F5> <Plug>(ide-debugger-run)
  nmap <buffer> <Leader><S-F5> <Plug>(ide-debugger-ui-toggle)
  nmap <buffer> <F6> <Plug>(ide-outline)
  nmap <buffer> <Leader><F10> <Plug>(ide-debugger-toggle-breakpoint)
  nmap <buffer> <Leader><S-F10> <Plug>(ide-debugger-toggle-breakpoint-conditional)
endfunction

function s:defineDebuggerMaps() abort
  nmap <buffer> <Leader><F6> <Plug>(ide-debugger-close)
  nmap <buffer> <Leader><S-F6> <Plug>(ide-debugger-detach)
  nmap <buffer> <Leader><F7> <Plug>(ide-debugger-step-into)
  nmap <buffer> <Leader><S-F7> <Plug>(ide-debugger-step-out)
  nmap <buffer> <Leader><F8> <Plug>(ide-debugger-step-over)
  nmap <buffer> <Leader><F9> <Plug>(ide-debugger-run-to-cursor)
  nmap <buffer> <Leader><F10> <Plug>(ide-debugger-toggle-breakpoint)
  nmap <buffer> <Leader><S-F10> <Plug>(ide-debugger-toggle-breakpoint-conditional)
  nmap <buffer> <Leader><F11> <Plug>(ide-debugger-get-context)
  nmap <buffer> <Leader><F12> <Plug>(ide-debugger-eval-under-cursor)
  nmap <buffer> <Leader><Leader>e <Plug>(ide-debugger-eval-visual)
  nmap <buffer> <Leader><Leader>p <Plug>(ide-debugger-eval-popup)
  xmap <buffer> <Leader><Leader>p <Plug>(ide-debugger-eval-popup)
  nmap <buffer> <Leader>k <Plug>(ide-debugger-up-frame)
  nmap <buffer> <Leader>j <Plug>(ide-debugger-down-frame)
endfunction

nmap <Leader>hs <Plug>(ide-git-hunk-stage)
nmap <Leader>g <Plug>(ide-git-status)
nmap <Leader>gc <Plug>(ide-git-commit)
nmap <Leader>gs <Plug>(ide-git-status)
nmap <Leader>gl <Plug>(ide-git-log)
nmap <Leader>gp <Plug>(ide-git-push-all)
nmap <Leader>hu <Plug>(ide-git-hunk-undo)
nmap <Leader>hp <Plug>(ide-git-hunk-print)
nmap <Leader>[h <Plug>(ide-git-hunk-previous-conflict)
nmap <Leader>]h <Plug>(ide-git-hunk-next-conflict)
nmap <Leader>fg <Plug>(ide-git-files-search-operator)
vmap <Leader>fg <Plug>(ide-git-files-search-operator)
nmap <S-F2> <Plug>(ide-git-stage-write-file)
imap <S-F2> <C-o><S-F2>
nmap [h <Plug>(ide-git-hunk-previous)
nmap ]h <Plug>(ide-git-hunk-next)

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

nmap <Esc> <Plug>(ide-close-popup)

command! IDEMapsEdit call arctgx#arctgx#editIDEMaps()
command! IDEMapsReload call arctgx#arctgx#reloadIDEMaps()
