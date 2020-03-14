augroup cocMaps
  autocmd!
  autocmd User CocJumpPlaceholder call
              \ CocActionAsync('showSignatureHelp')
  autocmd User CocNvimInit call <SID>defineIDEMaps()
  autocmd User CocNvimInit highlight CocFloating guifg=#888888 guibg=#dddddd
  autocmd User CocNvimInit highlight CocErrorFloat guifg=#880000 guibg=#dddddd
augroup END

function s:defineIDEMaps()
  nmap <Leader>ca <Plug>(coc-codeaction)
  nmap <Leader>cd <Plug>(coc-definition)
  nmap <Leader>cfh <Plug>(coc-float-hide)
  nmap <Leader>cfr <Plug>(coc-codelens-action)
  nmap <Leader>cmv <Plug>(coc-rename)
  nmap <Leader>cre <Plug>(coc-references)

  nmap <Plug>(ide-goto-definition) <Plug>(coc-definition)
  imap <Plug>(ide-show-signature-help) <C-o>:call CocActionAsync('showSignatureHelp')<CR>
  nmap <Plug>(ide-hover) <Cmd>call CocActionAsync('doHover')<CR>
  nmap <buffer> <Plug>(ide-find-references) <Cmd>call CocActionAsync('jumpReferences')<CR>
endfunction

inoremap <expr> <Plug>(ide-trigger-completion) coc#refresh()
inoremap <expr> <Plug>(ide-workspace-symbols) <Cmd>CocList symbols<CR>

let g:coc_config_home = get(g:, 'coc_config_home', expand('~/.vim'))
