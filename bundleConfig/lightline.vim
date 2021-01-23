function s:providePalette()
  let l:palette = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let l:blue   = [ '#61afef', 75 ]
  let l:purple = [ '#8798D6', 176 ]
  let l:red1   = [ '#e06c75', 168 ]
  let l:red2   = [ '#be5046', 168 ]
  let l:yellow = [ '#e5c07b', 180 ]

  if lightline#colorscheme#background() ==# 'light'
    let l:fg    = [ '#494b53', 238 ]
    let l:bg    = [ '#fafafa', 255 ]
    let l:gray1 = [ '#494b53', 238 ]
    let l:gray2 = [ '#f0f0f0', 255 ]
    let l:gray3 = [ '#d0d0d0', 250 ]
    let l:green = [ '#98c379', 35 ]

    let l:palette.inactive.left   = [ [ l:bg,  l:gray3 ], [ l:bg, l:gray3 ] ]
    let l:palette.inactive.middle = [ [ l:gray3, l:gray2 ] ]
    let l:palette.inactive.right  = [ [ l:bg, l:gray3 ] ]
  else
    let l:fg    = [ '#abb2bf', 145 ]
    let l:bg    = [ '#282c34', 235 ]
    let l:gray1 = [ '#5c6370', 241 ]
    let l:gray2 = [ '#2c323d', 235 ]
    let l:gray3 = [ '#3e4452', 240 ]
    let l:green  = [ '#98c379', 76 ]

    let l:palette.inactive.left   = [ [ l:gray1,  l:bg ], [ l:gray1, l:bg ] ]
    let l:palette.inactive.middle = [ [ l:gray1, l:gray2 ] ]
    let l:palette.inactive.right  = [ [ l:gray1, l:bg ] ]
  endif

  let l:palette.normal.left    = [ [ l:bg, l:green, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.normal.middle  = [ [ l:fg, l:gray2 ] ]
  let l:palette.normal.right   = [ [ l:bg, l:green, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.normal.error   = [ [ l:red2, l:bg ] ]
  let l:palette.normal.warning = [ [ l:yellow, l:bg ] ]
  let l:palette.insert.right   = [ [ l:bg, l:blue, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.insert.left    = [ [ l:bg, l:blue, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.replace.right  = [ [ l:bg, l:red1, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.replace.left   = [ [ l:bg, l:red1, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.visual.right   = [ [ l:bg, l:purple, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.visual.left    = [ [ l:bg, l:purple, 'bold' ], [ l:fg, l:gray3 ] ]
  let l:palette.tabline.left   = [ [ l:fg, l:gray3 ] ]
  let l:palette.tabline.tabsel = [ [ l:bg, l:purple, 'bold' ] ]
  let l:palette.tabline.middle = [ [ l:gray3, l:gray2 ] ]
  let l:palette.tabline.right  = copy(l:palette.normal.right)

  return l:palette
endfunction

let g:lightline#colorscheme#arctgx#palette = lightline#colorscheme#flatten(s:providePalette())

augroup LightLineReloadPalette
  autocmd!
  autocmd ColorScheme *
        \ let g:lightline#colorscheme#arctgx#palette = lightline#colorscheme#flatten(s:providePalette()) |
        \ call lightline#colorscheme() |
        \ call lightline#update()
  autocmd User IdeStatusChanged call lightline#update()
augroup END

let g:lightline = {
      \ 'colorscheme': 'arctgx',
      \ 'active': {
      \   'left': [
        \ [
          \ 'wininfo',
          \ 'paste',
        \ ],
        \ [
          \ 'branch',
          \ 'readonly',
          \ 'filename',
          \ 'modified',
        \ ]
      \ ],
      \ },
      \ 'inactive': {
      \   'left': [
        \ [
          \ 'wininfo',
          \ 'paste',
        \ ],
        \ [
          \ 'branch',
          \ 'readonly',
          \ 'filename',
          \ 'modified',
        \ ]
      \ ],
      \ },
      \ 'component_function': {
        \ 'wininfo': 'arctgx#ide#showWinInfo',
        \ 'filename': 'arctgx#ide#showLocation',
        \ 'branch': 'arctgx#ide#getCurrentGitHead',
      \ },
      \ 'tab_component_function': {
        \ 'filename': 'arctgx#ide#displayFileNameInTab',
        \ 'modified': 'lightline#tab#modified',
        \ 'readonly': 'lightline#tab#readonly',
        \ 'tabnum': 'lightline#tab#tabnum' }
      \ }
