augroup cocMaps
  autocmd!
  autocmd User CocJumpPlaceholder call
              \ CocActionAsync('showSignatureHelp')
  autocmd User CocNvimInit call s:defineIDEMaps()
  autocmd User CocNvimInit highlight CocFloating guifg=#888888 guibg=#dddddd
  autocmd User CocNvimInit highlight CocErrorFloat guifg=#880000 guibg=#dddddd
  autocmd User CocNvimInit highlight link CocErrorHighlight IdeDiagnosticError
  autocmd User CocNvimInit highlight link CocInfoHighlight IdeDiagnosticInfo
  autocmd User CocNvimInit highlight link CocHintHighlight IdeDiagnosticHint
  autocmd User CocNvimInit highlight link CocWarningHighlight IdeDiagnosticWarning
  autocmd User CocNvimInit highlight link CocErrorSign IdeErrorSign
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

function s:defineIDEMaps()
  nmap <Leader>ca <Plug>(coc-codeaction)
  nmap <Leader>cd <Plug>(coc-definition)
  nmap <Leader>cfh <Plug>(coc-float-hide)
  nmap <Leader>cfj <Plug>(coc-float-jump)
  nmap <Leader>col <Plug>(coc-openlink)
  nmap <Leader>cfr <Plug>(coc-codelens-action)
  nmap <Leader>cmv <Plug>(coc-rename)
  nmap <Leader>cre <Plug>(coc-references)

  nmap <Plug>(ide-goto-definition) <Plug>(coc-definition)
  nmap <Plug>(ide-goto-implementation) <Plug>(coc-implementation)
  imap <Plug>(ide-show-signature-help) <C-o>:call CocActionAsync('showSignatureHelp')<CR>
  nmap <Plug>(ide-hover) <Cmd>call CocActionAsync('doHover')<CR>
  nmap <Plug>(ide-find-references) <Plug>(coc-references)
  nmap <Plug>(ide-action-fold) <Cmd>call CocActionAsync('fold')<CR>
  nmap <Plug>(ide-action-rename) <Plug>(coc-rename)<CR>
  nmap <Plug>(ide-list-document-symbol) <Cmd>CocList outline<CR>
  nmap <Plug>(ide-list-workspace-symbol) <Cmd>CocList symbols<CR>
endfunction

inoremap <expr> <Plug>(ide-trigger-completion) coc#refresh()
inoremap <expr> <Plug>(ide-workspace-symbols) <Cmd>CocList symbols<CR>

let g:coc_config_home = expand(arctgx#arctgx#getInitialVimDirectory() . '/.config/coc')
let g:coc_data_home = expand(arctgx#arctgx#getInitialVimDirectory() . '/.config/coc')
let g:coc_enable_locationlist = 1
augroup CocRootPatterns
  autocmd!
  autocmd FileType php let b:coc_root_patterns = [
        \ "composer.json",
        \ "extensions.json",
        \ ".git",
        \ ".hg",
        \ ".projections.json"
        \ ]
augroup end
