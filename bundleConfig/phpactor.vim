let g:phpactorBranch = systemlist("git -C $HOME config --get submodule..vim/bundle/phpactor.branch")[0]
let g:phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'
let g:phpactorUseOpenWindows = v:true

augroup phpactor
  autocmd!
  autocmd FileType php call s:definePhpactorMaps()
  autocmd FileType php setlocal omnifunc=phpactor#Complete
augroup END

function s:definePhpactorMaps()
  nnoremap <buffer> <Leader>pm :call phpactor#ContextMenu()<CR>
  nnoremap <buffer> <Leader>pn :call phpactor#Navigate()<CR>
  " nmap <Plug>(ide-goto-definition) :call phpactor#GotoDefinition()<CR>
  nnoremap <buffer> <Plug>(ide-class-new) :call phpactor#ClassNew()<CR>
  nnoremap <buffer> <Plug>(ide-find-references) :call phpactor#FindReferences()<CR>
endfunction
