vim.o.swapfile = false
vim.go.backup = false
vim.go.mouse = 'a'
vim.go.mousemodel = 'extend'
vim.opt.backspace:append('nostop')
vim.bo.softtabstop = -1
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

vim.go.updatetime = 300
vim.wo.showbreak = '> '
vim.go.showmatch = false
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldtext = ''
vim.opt.fillchars:append({fold = ' '})
vim.go.pumblend = 15
vim.opt.complete:remove('t')
vim.opt.matchpairs:append('<:>')
vim.o.spell = false
vim.opt.spelloptions:append('camel')
vim.opt.spelloptions:append('noplainbuffer')
vim.go.splitbelow = true
vim.go.splitright = true
vim.go.equalalways = false
vim.go.eadirection = 'hor'
vim.opt.isfname:remove('=')

vim.opt.diffopt:append('vertical')
vim.opt.diffopt:remove('linematch:40')
vim.opt.diffopt:append('linematch:60')
vim.opt.jumpoptions:append('view')
vim.opt_global.shortmess:append('IcsS')

vim.go.foldlevelstart = 99
vim.wo.foldcolumn = 'auto'
vim.wo.number = true
vim.o.scrolloff = 5
vim.wo.smoothscroll = true
vim.wo.relativenumber = true
vim.wo.numberwidth = 1
vim.go.winminheight = 0
vim.go.switchbuf = 'useopen'
vim.go.wildmenu = true
vim.go.history = 1000
vim.go.laststatus = 2
vim.go.showtabline = 1
vim.go.tabline = "%!v:lua.require'arctgx.tabline'.prepare()"

vim.go.ignorecase = false
vim.go.wildignorecase = true
vim.bo.path = '.,,'
vim.opt.path:append(vim.fs.dirname(vim.env.VIMRUNTIME))
vim.opt.path:append(vim.env.VIMRUNTIME)
vim.go.showcmd = false
vim.go.showmode = false
vim.go.ruler = false

vim.opt.sessionoptions:remove('help')
vim.opt.sessionoptions:remove('folds')

vim.opt.signcolumn = 'auto:1-9'
vim.opt.tags = ''
vim.go.listchars = 'eol:$,tab:>-,trail:~,extends:>,precedes:<'
