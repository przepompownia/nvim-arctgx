scriptencoding utf-8

filetype plugin indent on

let g:mapleader=','
if empty(get(g:, 'bundle_dirs', v:null))
  throw 'Set optional extension directory (g:bundle_dirs) before'
endif

if has('mouse')
  set mouse=a
endif

set mousemodel=extend

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
set nospell
set spelloptions+=camel,noplainbuffer
set splitbelow
set splitright
set noequalalways
set eadirection=hor
"set clipboard=unnamed
set isfname-==
set modeline modelines=5

set diffopt+=vertical,linematch:60
set jumpoptions+=view
if has('folding')
  set foldlevelstart=99

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
set wildignorecase
set path=.,,
set showcmd
set noswapfile
set autoread
set sessionoptions-=help
set sessionoptions-=folds
set sessionoptions-=buffers
set grepprg=grep\ --with-filename\ --extended-regexp\ --no-messages\ --color=never\ --binary-files=without-match\ --exclude-dir=.svn\ --exclude-dir=.git\ --line-number
if has('nvim')
  set signcolumn=auto:1-9
endif

" set tags=./tags;/
set tags=

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

set title
let &titleold=printf('%s %s', strftime('%F %H:%M:%S'), getcwd())
