augroup cocInit
  autocmd!
  autocmd User CocNvimInit
        \ call s:defineIDEMaps() |
        \ call s:loadColorSettings() |
        \ call s:autocommandsAfterInit()
augroup END

function s:autocommandsAfterInit() abort
  augroup cocAfterInit
    autocmd!
    autocmd User CocJumpPlaceholder
          \ call CocActionAsync('showSignatureHelp')
    autocmd BufWritePost * CocCommand git.refresh
    autocmd User ChangeIdeStatus CocCommand git.refresh
    autocmd ColorScheme * call s:loadColorSettings()
    autocmd CursorHold * call s:onCursorHold()
    autocmd QuitPre * execute "normal \<Plug>(coc-float-hide)"
  augroup END
endfunction

function s:onCursorHold()
  silent call CocActionAsync('highlight')
  silent call CocActionAsync('getCurrentFunctionSymbol', function('arctgx#coc#setCurrentFunctionCallback'))
endfunction

function s:loadColorSettings()
  sign define CocHint text=💡 linehl=CocHintLine texthl=IdeHintSign numhl=IdeLineNrHint
  sign define CocInfo text=🛈  linehl=CocInfoLine texthl=IdeInfoSign numhl=IdeLineNrInfo
  sign define CocWarning text=⚠ linehl=CocWarningLine texthl=IdeWarningSign numhl=IdeLineNrWarning
  sign define CocError text=✗ linehl=CocErrorLine texthl=IdeErrorSign numhl=IdeLineNrError
  highlight link CocFloating IdeFloating
  highlight link CocErrorFloat IdeErrorFloat
  highlight link CocHintFloat IdeHintFloat
  highlight link CocInfoFloat IdeInfoFloat
  highlight link CocWarningFloat IdeWarningFloat
  highlight link CocErrorHighlight IdeDiagnosticError
  highlight link CocInfoHighlight IdeDiagnosticInfo
  highlight link CocHintHighlight IdeDiagnosticHint
  highlight link CocWarningHighlight IdeDiagnosticWarning
  highlight link CocErrorSign IdeErrorSign
  highlight link CocInfoSign IdeInfoSign
  highlight link CocHintSign IdeHintSign
  highlight link CocWarningSign IdeWarningSign
endfunction

" function! s:check_back_space() abort
  " let l:col = col('.') - 1
  " return !l:col || getline('.')[l:col - 1]  =~# '\s'
" endfunction

function s:defineIDEMaps()
  " inoremap <silent><expr> <TAB>
    " \ pumvisible() ? coc#_select_confirm() :
    " \ coc#expandableOrJumpable() ?
    " \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    " \ <SID>check_back_space() ? "\<TAB>" :
    " \ coc#refresh()

  " let g:coc_snippet_next = '<tab>'
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  " inoremap <silent><expr> <C-s> coc#rpc#request('doKeymap', ['snippets-expand-jump',''])
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<C-f>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<C-b>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif
  nmap <Leader>ca <Plug>(coc-codeaction)
  nmap <Leader>cd <Plug>(coc-definition)
  nmap <Leader>col <Plug>(coc-openlink)
  nmap <Leader>cfr <Plug>(coc-codelens-action)
  nmap <Leader>cmv <Plug>(coc-rename)
  nmap <Leader>cre <Plug>(coc-references)
  xmap <leader>ccs <Plug>(coc-convert-snippet)

  nmap <Plug>(ide-goto-definition) <Plug>(coc-definition)
  nmap <Plug>(ide-goto-implementation) <Plug>(coc-implementation)
  imap <Plug>(ide-show-signature-help) <C-o>:call CocActionAsync('showSignatureHelp')<CR>
  nmap <Plug>(ide-find-references) <Plug>(coc-references)
  nmap <Plug>(ide-action-rename) <Plug>(coc-rename)<CR>
  nmap <buffer> <Plug>(ide-range-select) <Plug>(coc-range-select)
  nmap <Plug>(ide-git-hunk-previous) <Plug>(coc-git-prevchunk)
  nmap <Plug>(ide-git-hunk-next) <Plug>(coc-git-nextchunk)
  nmap <Plug>(ide-git-hunk-previous-conflict) <Plug>(coc-git-prevconflict)
  nmap <Plug>(ide-git-hunk-next-conflict) <Plug>(coc-git-nextconflict)
  nmap <Plug>(ide-diagnostic-info) <Plug>(coc-diagnostic-info)
  imap <silent><expr> <Plug>(ide-trigger-completion) coc#refresh()
  nmap <Plug>(ide-git-hunk-stage) <Cmd>CocCommand git.chunkStage<CR>
  nmap <Plug>(ide-git-hunk-undo) <Cmd>CocCommand git.chunkUndo<CR>
  nmap <Plug>(ide-git-hunk-print) <Cmd>CocCommand git.chunkInfo<CR>
  nmap <Plug>(ide-list-workspace-symbols) <Cmd>CocList symbols<CR>
  nmap <Plug>(ide-list-document-symbols) <Cmd>CocList outline<CR>
  nmap <Plug>(ide-hover) <Cmd>call CocActionAsync('doHover')<CR>
  nmap <Plug>(ide-action-fold) <Cmd>call CocActionAsync('fold')<CR>
  nmap <Plug>(ide-outline) <Cmd>call CocActionAsync('showOutline', 0)<CR>
endfunction

let g:coc_config_home = expand('<sfile>:p:h')
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
