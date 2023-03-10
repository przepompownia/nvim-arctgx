vim.g.mapleader = ','
vim.go.mouse = 'a'
vim.go.mousemodel = 'extend'
vim.go.backspace = 'indent,eol,start'
vim.bo.softtabstop = -1
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

vim.go.backup = false
vim.go.updatetime = 300
vim.o.showbreak = '> '
vim.go.showmatch = false

if 1 == vim.fn.has('nvim-0.9') then
  vim.opt.shortmess:append('C')
end

vim.opt.complete:remove('t')
vim.opt.matchpairs:append('<:>')
vim.opt.spell = false
vim.opt.spelloptions:append('camel')
vim.opt.spelloptions:append('noplainbuffer')
vim.go.splitbelow = true
vim.go.splitright = true
vim.go.equalalways = false
vim.go.eadirection = 'hor'
vim.opt.isfname:remove('=')

vim.opt.diffopt:append('vertical')
if 1 == vim.fn.has('nvim-0.9') then
  vim.opt.diffopt:append('linematch:60')
end
vim.opt.jumpoptions:append('view')

vim.go.foldlevelstart = 99
vim.wo.foldcolumn = 'auto'
vim.wo.number = 1
vim.wo.numberwidth = 1
vim.go.winminheight = 0
vim.go.switchbuf = 'usetab'
vim.go.wildmenu = true
vim.go.history = 1000
vim.go.laststatus = 2
vim.opt.completeopt:remove('preview')

vim.go.ignorecase = false
vim.go.wildignorecase = true
vim.bo.path = '.,,'
vim.go.showcmd = true
vim.opt.swapfile = false

vim.opt.sessionoptions:remove('help')
vim.opt.sessionoptions:remove('buffers')
vim.opt.sessionoptions:remove('folds')

vim.opt.signcolumn = 'auto:1-9'
vim.opt.tags = ''
vim.opt.listchars = 'eol:$,tab:>-,trail:~,extends:>,precedes:<'
