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

function! s:check_back_space() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~# '\s'
endfunction

function s:defineIDEMaps()
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ?
    \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

  let g:coc_snippet_next = '<tab>'

  nmap <Leader>ca <Plug>(coc-codeaction)
  nmap <Leader>cd <Plug>(coc-definition)
  nmap <Leader>cfh <Plug>(coc-float-hide)
  nmap <Leader>cfj <Plug>(coc-float-jump)
  nmap <Leader>col <Plug>(coc-openlink)
  nmap <Leader>cfr <Plug>(coc-codelens-action)
  nmap <Leader>cmv <Plug>(coc-rename)
  nmap <Leader>cre <Plug>(coc-references)
  xmap <leader>ccs <Plug>(coc-convert-snippet)
  nnoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Right>"
  inoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Left>"

  nmap <Plug>(ide-goto-definition) <Plug>(coc-definition)
  nmap <Plug>(ide-goto-implementation) <Plug>(coc-implementation)
  imap <Plug>(ide-show-signature-help) <C-o>:call CocActionAsync('showSignatureHelp')<CR>
  nmap <Plug>(ide-hover) <Cmd>call CocActionAsync('doHover')<CR>
  nmap <Plug>(ide-find-references) <Plug>(coc-references)
  nmap <Plug>(ide-action-fold) <Cmd>call CocActionAsync('fold')<CR>
  nmap <Plug>(ide-action-rename) <Plug>(coc-rename)<CR>
  nmap <Plug>(ide-list-document-symbol) <Cmd>CocList outline<CR>
  nmap <Plug>(ide-list-workspace-symbol) <Cmd>CocList symbols<CR>
  nmap <buffer> <Plug>(ide-range-select) <Plug>(coc-range-select)
  xmap <buffer> <Plug>(ide-funcobj-i) <Plug>(coc-funcobj-i)
  omap <buffer> <Plug>(ide-funcobj-i) <Plug>(coc-funcobj-i)
  xmap <buffer> <Plug>(ide-funcobj-a) <Plug>(coc-funcobj-a)
  omap <buffer> <Plug>(ide-funcobj-a) <Plug>(coc-funcobj-a)
  xmap <buffer> <Plug>(ide-classobj-i) <Plug>(coc-classobj-i)
  omap <buffer> <Plug>(ide-classobj-i) <Plug>(coc-classobj-i)
  xmap <buffer> <Plug>(ide-classobj-a) <Plug>(coc-classobj-a)
  omap <buffer> <Plug>(ide-classobj-a) <Plug>(coc-classobj-a)
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
