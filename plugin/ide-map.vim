augroup ideMaps
  autocmd!
  autocmd FileType * call s:defineIDEMaps()
  autocmd User IDEDebuggerMapsNeeded call s:defineDebuggerMaps()
augroup END

function s:isExcludedFromIDEMapping(filetype)
  let l:excludedFiletypes = ['man', 'help', 'dbout']

  return index(l:excludedFiletypes, a:filetype) >= 0
endfunction

function s:defineIDEMaps()
  if s:isExcludedFromIDEMapping(&filetype)
    return
  endif

  imap <buffer> <C-\>, <Plug>(ide-show-signature-help)
  imap <buffer> <C-Space> <Plug>(ide-trigger-completion)
  nmap <buffer> <C-]> <Plug>(ide-goto-definition)
  nmap <buffer> <C-LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> g<LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>icn <Plug>(ide-class-new)
  nmap <buffer> <Leader>igd <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>igi <Plug>(ide-goto-implementation)
  nmap <buffer> <Leader>ifr <Plug>(ide-find-references)
  nmap <buffer> <Leader>inm <Plug>(ide-navigation-menu)
  nmap <buffer> <Leader>ih <Plug>(ide-hover)
  nmap <buffer> <Leader>iaf <Plug>(ide-action-fold)
  nmap <buffer> <Leader>iar <Plug>(ide-action-rename)
  nmap <buffer> <Leader>ilo <Plug>(ide-list-document-symbol)
  nmap <buffer> <Leader>ilf <Plug>(ide-list-document-functions)
  nmap <buffer> <Leader>ilw <Plug>(ide-list-workspace-symbols)
  nmap <buffer> <Leader>irs <Plug>(ide-range-select)
  xmap <buffer> <Leader>irfi <Plug>(ide-funcobj-i)
  omap <buffer> <Leader>irfi <Plug>(ide-funcobj-i)
  xmap <buffer> <Leader>irfa <Plug>(ide-funcobj-a)
  omap <buffer> <Leader>irfa <Plug>(ide-funcobj-a)
  xmap <buffer> <Leader>irci <Plug>(ide-classobj-i)
  omap <buffer> <Leader>irci <Plug>(ide-classobj-i)
  xmap <buffer> <Leader>irca <Plug>(ide-classobj-a)
  omap <buffer> <Leader>irca <Plug>(ide-classobj-a)

  nmap <buffer> <Leader><F5> <Plug>(ide-debugger-run)
  nmap <buffer> <Leader><F10> <Plug>(ide-debugger-toggle-breakpoint)
endfunction

function s:defineDebuggerMaps() abort
  nmap <buffer> <Leader><F5> <Plug>(ide-debugger-run)
  nmap <buffer> <Leader><F6> <Plug>(ide-debugger-close)
  nmap <buffer> <Leader><S-F6> <Plug>(ide-debugger-detach)
  nmap <buffer> <Leader><F7> <Plug>(ide-debugger-step-into)
  nmap <buffer> <Leader><S-F7> <Plug>(ide-debugger-step-out)
  nmap <buffer> <Leader><F8> <Plug>(ide-debugger-step-over)
  nmap <buffer> <Leader><F9> <Plug>(ide-debugger-run-to-cursor)
  nmap <buffer> <Leader><F10> <Plug>(ide-debugger-toggle-breakpoint)
  nmap <buffer> <Leader><F11> <Plug>(ide-debugger-get-context)
  nmap <buffer> <Leader><F12> <Plug>(ide-debugger-eval-under-cursor)
  nmap <buffer> <Leader><Leader>e <Plug>(ide-debugger-eval-visual)
endfunction

nmap <Leader>hs <Plug>(ide-git-hunk-stage)
nmap <Leader>hu <Plug>(ide-git-hunk-undo)
nmap <Leader>hp <Plug>(ide-git-hunk-print)
nmap <Leader>[h <Plug>(ide-git-hunk-previous-conflict)
nmap <Leader>]h <Plug>(ide-git-hunk-next-conflict)
nmap <S-F2> <Plug>(ide-git-stage-write-file)
imap <S-F2> <C-o><S-F2>
nmap [h <Plug>(ide-git-hunk-previous)
nmap ]h <Plug>(ide-git-hunk-next)

nmap <Leader>ibb <Plug>(ide-browse-buffers)
nmap <S-F1> <Plug>(ide-browse-buffers)
imap <S-F1> <C-o><S-F1>
nmap <Leader>; <Plug>(ide-browse-cmd-history)
nmap <Leader>ibh <Plug>(ide-browse-history)
nmap <F4> <Plug>(ide-browse-history)
imap <F4> <C-o><F4>
nmap <S-F4> <Plug>(ide-git-show-branches)
imap <S-F4> <C-o><S-F4>
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

command! IDEMapsEdit call arctgx#arctgx#editIDEMaps()
command! IDEMapsReload call arctgx#arctgx#reloadIDEMaps()
