augroup ideMaps
  autocmd!
  autocmd FileType * call <SID>defineIDEMaps()
augroup END

function s:isExcludedFromIDEMapping(filetype)
  let l:excludedFiletypes = ['man', 'help']

  return index(l:excludedFiletypes, a:filetype) >= 0
endfunction

function s:defineIDEMaps()
  if <SID>isExcludedFromIDEMapping(&filetype)
    return
  endif

  imap <buffer> <C-\>, <Plug>(ide-show-signature-help)
  imap <buffer> <C-Space> <Plug>(ide-trigger-completion)
  nmap <buffer> <C-]> <Plug>(ide-goto-definition)
  nmap <buffer> <C-LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> g<LeftMouse> <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>icn <Plug>(ide-class-new)
  nmap <buffer> <Leader>igd <Plug>(ide-goto-definition)
  nmap <buffer> <Leader>ifr <Plug>(ide-find-references)
  nmap <buffer> <Leader>inm <Plug>(ide-navigation-menu)
  nmap <buffer> <Leader>iws <Plug>(ide-workspace-symbols)
  nmap <buffer> <Leader>ih <Plug>(ide-hover)
endfunction

nmap <Leader>ibb <Plug>(ide-browse-buffers)
nmap <Leader>; <Plug>(ide-browse-cmd-history)
nmap <Leader>ibh <Plug>(ide-browse-history)
nmap <Leader>ibf <Plug>(ide-browse-files)
nmap <Leader>ibg <Plug>(ide-browse-gfiles)
nmap <Leader>ibw <Plug>(ide-browse-windows)

command! IDEMapsEdit call arctgx#arctgx#editIDEMaps()
command! IDEMapsReload call arctgx#arctgx#reloadIDEMaps()
