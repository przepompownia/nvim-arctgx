augroup ideMaps
  autocmd!
  autocmd FileType * call s:defineIDEMaps()
augroup END

function s:isExcludedFromIDEMapping(filetype)
  let l:excludedFiletypes = ['man', 'help']

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
  nmap <buffer> <Leader>iws <Plug>(ide-workspace-symbols)
  nmap <buffer> <Leader>ih <Plug>(ide-hover)
  nmap <buffer> <Leader>iaf <Plug>(ide-action-fold)
  nmap <buffer> <Leader>iar <Plug>(ide-action-rename)
  nmap <buffer> <Leader>ilo <Plug>(ide-list-document-symbol)
  nmap <buffer> <Leader>ilf <Plug>(ide-list-document-functions)
  nmap <buffer> <Leader>ilw <Plug>(ide-list-workspace-symbol)
  nmap <buffer> <Leader>irs <Plug>(ide-range-select)
  xmap <buffer> <Leader>irfi <Plug>(ide-funcobj-i)
  omap <buffer> <Leader>irfi <Plug>(ide-funcobj-i)
  xmap <buffer> <Leader>irfa <Plug>(ide-funcobj-a)
  omap <buffer> <Leader>irfa <Plug>(ide-funcobj-a)
  xmap <buffer> <Leader>irci <Plug>(ide-classobj-i)
  omap <buffer> <Leader>irci <Plug>(ide-classobj-i)
  xmap <buffer> <Leader>irca <Plug>(ide-classobj-a)
  omap <buffer> <Leader>irca <Plug>(ide-classobj-a)
endfunction

nmap <Leader>ibb <Plug>(ide-browse-buffers)
nmap <S-F1> <Plug>(ide-browse-buffers)
nmap <Leader>; <Plug>(ide-browse-cmd-history)
nmap <Leader>ibh <Plug>(ide-browse-history)
nmap <F4> <Plug>(ide-browse-history)
nmap <Leader>ibf <Plug>(ide-browse-files)
nmap <Leader>ibg <Plug>(ide-browse-gfiles)
nmap <Leader>ibw <Plug>(ide-browse-windows)
nmap <F1> <Plug>(ide-browse-windows)
inoremap <F1> <C-o>(ide-browse-windows)

nmap <Leader>igg <Plug>(ide-grep-git)
nmap <Leader>igf <Plug>(ide-grep-files)

command! IDEMapsEdit call arctgx#arctgx#editIDEMaps()
command! IDEMapsReload call arctgx#arctgx#reloadIDEMaps()
