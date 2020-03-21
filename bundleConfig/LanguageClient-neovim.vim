let g:LanguageClient_serverCommands = get(g:, 'LanguageClient_serverCommands', {})

" let g:LanguageClient_serverCommands['php'] = ['php', exepath('php-language-server.php')]
let g:LanguageClient_serverCommands['rust'] = [exepath('rls')]
let g:LanguageClient_serverCommands['sh'] = [exepath('bash-language-server'), 'start']
let g:LanguageClient_serverCommands['vim'] = ['/home/arctgx/hj/external/vim-language-server/bin/index.js', '--stdio']
" let g:LanguageClient_serverCommands['vim'] = [exepath('vim-language-server'), '--stdio']
let g:LanguageClient_windowLogMessageLevel = 'Warning'
let g:LanguageClient_loggingFile = expand('/tmp/lc-client.log')
let g:LanguageClient_serverStderr = '/tmp/lc-serverStderr'
" let g:LanguageClient_diagnosticsList = 'Location'
let g:LanguageClient_completionPreferTextEdit = 1
let g:LanguageClient_rootMarkers = {
    \ 'vim': ['vimrc_per_host'],
    \ }
let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_serverStderr = '/tmp/lc-debug.txt'
let g:LanguageClient_trace = 'verbose'
let g:LanguageClient_hoverPreview = 'Always'

augroup LanguageClient
  autocmd!
  autocmd FileType * call <SID>define_maps()
  autocmd FileType vim let g:LanguageClient_settingsPath = arctgx#arctgx#getInitialVimDirectory() . '/pack/bundle/start/arctgx/languageServerConfig/vim-language-server.json'
augroup END

function s:define_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer><expr> <C-]> LanguageClient#textDocument_definition()
    nnoremap <buffer><expr> g<LeftMouse> LanguageClient#textDocument_definition()
    nnoremap <buffer><expr> <C-LeftMouse> LanguageClient#textDocument_definition()
    nnoremap <buffer> <Leader>lm :call LanguageClient_contextMenu()<CR>
    nnoremap <buffer> <Leader>lh :call LanguageClient_textDocument_hover()<CR>
  endif
endfunction
