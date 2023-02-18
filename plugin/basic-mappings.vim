scriptencoding utf-8

for i in range(1, 12)
  execute 'map <F' .. (12 + i) .. '> <S-F' .. i .. '>'
endfor
nnoremap i <Cmd>call arctgx#arctgx#insertWithInitialIndentation('i')<CR>
nnoremap a <Cmd>call arctgx#arctgx#insertWithInitialIndentation('a')<CR>
nnoremap <Leader>fcc <Cmd>let @+ = expand('%:.')<CR>
tnoremap <expr> <M-p> '<C-\><C-N>"' .. nr2char(getchar()) .. 'pi'
nnoremap <C-Tab> <Cmd>tabNext<CR>
inoremap <C-Tab> <Cmd>tabNext<CR>

noremap <silent> <A-Up> <Cmd>wincmd k<CR>
noremap <silent> <A-Down> <Cmd>wincmd j<CR>
noremap <silent> <A-Left> <Cmd>wincmd h<CR>
noremap <silent> <A-Right> <Cmd>wincmd l<CR>
inoremap <silent> <A-Up> <Cmd>wincmd k<CR>
inoremap <silent> <A-Down> <Cmd>wincmd j<CR>
inoremap <silent> <A-Left> <Cmd>wincmd h<CR>
inoremap <silent> <A-Right> <Cmd>wincmd l<CR>
inoremap <C-BS> <Cmd>normal db<CR>
inoremap <C-Del> <Cmd>normal dw<CR>
inoremap <F2> <Cmd>update<CR>
noremap <F2> <Cmd>update<CR>
noremap <F3> <Cmd>quit<CR>
inoremap <F3> <Cmd>quit<CR>
noremap <S-F3> <Cmd>quit!<CR>
noremap <F15> <Cmd>quit!<CR>
inoremap <S-F3> <Cmd>quit!<CR>
inoremap <F15> <Cmd>quit!<CR>
inoremap <C-Left> <Cmd>normal b<CR>
inoremap <C-Right> <Cmd>normal w<CR>
inoremap <S-Right> <Cmd>normal v<CR>
inoremap <S-Left> <Cmd>normal v<CR>
inoremap <C-z> <C-x><C-o>
noremap <Leader>co <Cmd>copen<CR>
nnoremap <Leader>hls <Cmd>let @/ = ''<CR>
