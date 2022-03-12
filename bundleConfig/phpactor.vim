let g:phpactorUseOpenWindows = v:true
let g:PhpactorRootDirectoryStrategy = {-> get(get(b:, 'project', {}), 'primaryRootPath', g:phpactorInitialCwd)}

augroup phpactor
  autocmd!
  autocmd FileType php call s:definePhpactorMaps()
  autocmd FileType php setlocal omnifunc=phpactor#Complete
augroup END

function s:definePhpactorMaps()
  nnoremap <buffer> <Leader>pm :call phpactor#ContextMenu()<CR>
  nnoremap <buffer> <Leader>pn :call phpactor#Navigate()<CR>
  nnoremap <buffer> <Leader>pfr :call phpactor#FindReferences()<CR>
endfunction

lua << EOF
-- todo buffer
vim.keymap.set('n', '<Plug>(ide-class-new)', require('arctgx.phpactor').class_new)
EOF
