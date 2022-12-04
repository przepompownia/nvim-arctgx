function! s:configureHighlight(background) abort
  let l:path = simplify(fnamemodify(printf(
        \ '%s/../colors/%s.vim',
        \ s:path,
        \ a:background
        \ ), ':p'))
  call arctgx#base#sourceFile(l:path)
endfunction

let s:path = expand('<sfile>:p:h')
let s:bundleConfigDir = simplify(s:path . '/../bundleConfig/')
let g:bundle_dirs = get(g:, 'bundle_dirs', [])
try
  if empty(g:bundle_dirs)
    throw 'Empty g:bundle_dirs'
  endif
  call arctgx#bundle#loadCustomConfigurations(g:bundle_dirs, s:bundleConfigDir)
  set termguicolors
  call arctgx#term#loadConfiguration(s:path . '/../termConfig')
  call s:configureHighlight(&background)
catch /^Vim\%((\a\+)\)\=:E117/
  echomsg v:exception
endtry

augroup ConfigureHighlight
  autocmd!
  autocmd ColorScheme *
        \ call s:configureHighlight(&background)
augroup END

augroup AfterVimEnter
  autocmd!
  autocmd VimEnter * ++nested set background=light
  autocmd VimEnter * :clearjumps
augroup END

command! -complete=packadd -nargs=1 Packadd call arctgx#bundle#packadd(<q-args>, s:bundleConfigDir)
