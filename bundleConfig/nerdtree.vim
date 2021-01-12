nnoremap <Leader>m :call arctgx#nerdtree#find()<CR>
nnoremap <Leader>nb :NERDTree <CR> :OpenBookmark<Space>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeBookmarksFile = expand('~/.config/NERDTreeBookmarks.cfg')
let g:NERDTreeMouseMode = 2
let g:NERDChristmasTree = 1
let g:NERDTreeQuitOnOpen = 3
let g:NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 't'}, 'dir': {}}
let g:NERDTreeHighlightCursorline =1
augroup NERDTreeVimEnter
  autocmd!
  autocmd VimEnter * call NERDTreeAddMenuItem({
        \ 'text': '(s)hell: open here',
        \ 'shortcut': 's',
        \ 'callback': 'arctgx#nerdtree#openShellHere'
        \})
  autocmd VimEnter * call NERDTreeAddMenuItem({
        \ 'text': '(f)zf: open here',
        \ 'shortcut': 'f',
        \ 'isActiveCallback': 'arctgx#nerdtree#canOpenFzfFiles',
        \ 'callback': 'arctgx#nerdtree#openFzfHere'
        \})
augroup END
