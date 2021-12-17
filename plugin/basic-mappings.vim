scriptencoding utf-8
nnoremap i :call arctgx#arctgx#insertWithInitialIndentation('i')<CR>
nnoremap a :call arctgx#arctgx#insertWithInitialIndentation('a')<CR>
xnoremap <C-Insert> "*y
inoremap <C-q> <C-r>+
noremap <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>
tnoremap <S-Insert> <C-\><C-N>"*pi
tnoremap <expr> <M-p> '<C-\><C-N>"'.nr2char(getchar()).'pi'
nnoremap <Tab> <C-w>w
nnoremap <C-Tab> :tabNext<CR>
inoremap <C-Tab> <C-o>:tabNext<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap g<Left> <C-o>
nnoremap g<Right> <C-^>

noremap <silent> <A-Up> <Cmd>wincmd k<CR>
noremap <silent> <A-Down> <Cmd>wincmd j<CR>
noremap <silent> <A-Left> <Cmd>wincmd h<CR>
noremap <silent> <A-Right> <Cmd>wincmd l<CR>
inoremap <silent> <A-Up> <Cmd>wincmd k<CR>
inoremap <silent> <A-Down> <Cmd>wincmd j<CR>
inoremap <silent> <A-Left> <Cmd>wincmd h<CR>
inoremap <silent> <A-Right> <Cmd>wincmd l<CR>
inoremap <Insert> <Nop>
inoremap <C-BS> <Cmd>normal db<CR>
inoremap <C-Del> <Cmd>normal dw<CR>
noremap Q <Nop>
inoremap <F2> <C-o>:update<CR>
noremap <F2> <ESC>:update<CR>
noremap <F3> <ESC>:q<CR>
inoremap <F3> <C-o>:q<CR>
noremap <S-F3> <ESC>:q!<CR>
noremap <F15> <ESC>:q!<CR>
inoremap <S-F3> <C-o>:q!<CR>
inoremap <F15> <C-o>:q!<CR>
inoremap <C-Left> <Cmd>normal b<CR>
inoremap <C-Right> <Cmd>normal w<CR>
inoremap <S-Right> <Cmd>normal v<CR>
inoremap <S-Left> <Cmd>normal v<CR>
noremap <S-Up> <C-y>
noremap <S-Down> <C-e>
inoremap <C-z> <C-x><C-o>
noremap ]q :cnext<CR>
noremap [q :cprev<CR>
noremap <Leader>co :copen<CR>
noremap / /\c
noremap <Leader>/ /
noremap ? ?\c
nnoremap <Leader>= ggVG=
nnoremap <Leader>hls :let @/ = ''<CR>
noremap zDDD zD
noremap zddd zd
noremap zEEE zE
noremap zD <Nop>
noremap zd <Nop>
noremap zE <Nop>
nmap <silent> <Leader>` <Plug>(jump-last-tab)
set pastetoggle=<Nop>
