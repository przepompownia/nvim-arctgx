scriptencoding utf-8

if has('syntax')
  syntax on
endif
filetype plugin indent on

let g:mapleader=','
let g:bundle_dirs = [expand(g:initialVimDirectory . '/pack/bundle/opt')]

if has('mouse')
  set mouse=a
endif

set backspace=indent,eol,start

set softtabstop=-1 " the value of 'shiftwidth' is used
set tabstop=4
set shiftwidth=4

set hidden
set nobackup
set updatetime=300
set hlsearch
set incsearch
set wrapscan
let &showbreak='> '

set noruler
set noshowmatch

set matchpairs+=<:>
set spelllang=pl
set splitbelow
set splitright
set noequalalways
set eadirection=hor
"set clipboard=unnamed
set isfname-==
"set shellcmdflag=-ic
set modeline modelines=5

set diffopt+=vertical
if has('folding')
  set foldlevelstart=99

  let g:javaScript_fold=1
  let g:perl_fold=1
  let g:php_folding=0
  let g:r_syntax_folding=1
  let g:ruby_fold=1
  let g:sh_fold_enabled=1
  let g:vimsyn_folding='af'
  " let g:xml_syntax_folding=0
  set foldcolumn=1

  set foldtext=arctgx#fold#foldText()
endif

set number
set numberwidth=1
set winminheight=0
set switchbuf=usetab

set backupdir=~/.cache/vim,.
set directory=~/.cache/vim,.
set wildmenu
set history=1000
set laststatus=2
set completeopt-=preview
set noignorecase
if (v:version >= 703)
  set wildignorecase
endif
set path=.,,
set showcmd
set noswapfile
set autoread
set sessionoptions-=help
set sessionoptions-=folds
set grepprg=grep\ --with-filename\ --extended-regexp\ --no-messages\ --color=never\ --binary-files=without-match\ --exclude-dir=.svn\ --exclude=tags\ --exclude=taglist.vim\ --exclude-dir=.git\ --line-number
set signcolumn=auto:1-9

" set tags=./tags;/
set tags=

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

set title
let &titleold=printf('%s %s', strftime('%F %H:%M:%S'), getcwd())

