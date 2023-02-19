local keymap = require 'arctgx.vim.keymap'
local base   = require 'arctgx.base'
local api = vim.api

---@type KeyToPlugMappings
local mapToKeySequenceList = {
  ['<Leader>='] = {rhs = 'ggVG=', modes = {'n', 'v'}},
  ['<Leader>/'] = {rhs = '/', modes = {'n'}},
  ['<Leader>?'] = {rhs = '?', modes = {'n'}},
  ['/'] = {rhs = '/\\c', modes = {'n'}},
  ['?'] = {rhs = '?\\c', modes = {'n'}},
  ['<C-q>'] = {rhs = '<C-r>+', modes = {'i'}},
  ['<C-Insert>'] = {rhs = '"*y', modes = {'x'}},
  ['<C-S-Insert>'] = {rhs = '"+y', modes = {'x'}},
  ['<S-Insert>'] = {rhs = '<MiddleMouse>', modes = {'!'}},
  ['<Tab>'] = {rhs = '<C-w>w', modes = {'n', 'v'}},
  ['g<Left>'] = {rhs = '<C-O>', modes = {'n'}},
  ['g<Right>'] = {rhs = '<C-I>', modes = {'n'}},
  ['<Insert>'] = {rhs = '<Nop>', modes = {'i'}},
  ['<C-z>'] = {rhs = '<C-x><C-o>', modes = {'i'}},
  ['Q'] = {rhs = '<Nop>', modes = {'n'}},
  ['<C-BS>'] = {rhs = '<C-w>', modes = {'c'}},
  ['<C-Del>'] = {rhs = '<S-Right><C-w>', modes = {'c'}},
  ['<S-Up>'] = {rhs = '<C-y>', modes = {'n'}},
  ['<S-Down>'] = {rhs = '<C-e>', modes = {'n'}},
}
keymap.loadKeyToPlugMappings(mapToKeySequenceList)

local opts = {silent = true}

vim.keymap.set('t', '<S-Insert>', '<C-\\><C-N>"*pi', opts)
vim.keymap.set('n', 'i', function() base.insertWithInitialIndentation('i') end, opts)
vim.keymap.set('n', 'a', function() base.insertWithInitialIndentation('a') end, opts)
vim.keymap.set('n', '<Leader>fcc', function() vim.fn.setreg('+', vim.fn.expand('%:.')) end, opts)
vim.keymap.set('n', '<Leader>hls', function() vim.fn.setreg('/', '') end, opts)
vim.keymap.set('n', '<Leader>co', vim.cmd.copen, opts)
vim.keymap.set('t', '<M-p>', function()
  local regname = vim.fn.nr2char(vim.fn.getchar())
  local sequence = ('<C-\\><C-n>"%spi'):format(regname)
  return api.nvim_replace_termcodes(sequence, true, false, true)
end, {
  silent = true,
  expr = true,
})

for i = 1, 12 do
  vim.keymap.set({'n', 'i'}, '<F' .. 12 + i .. '>', function ()
    vim.cmd.normal(api.nvim_replace_termcodes('<S-F' .. i .. '>', true, false, true))
  end, {})
end

vim.keymap.set({'i', 'n'}, '<A-Up>', function() vim.cmd.wincmd('k') end, opts)
vim.keymap.set({'i', 'n'}, '<A-Down>', function() vim.cmd.wincmd('j') end, opts)
vim.keymap.set({'i', 'n'}, '<A-Left>', function() vim.cmd.wincmd('h') end, opts)
vim.keymap.set({'i', 'n'}, '<A-Right>', function() vim.cmd.wincmd('l') end, opts)
vim.keymap.set('i', '<C-BS>', function() vim.cmd.normal('db') end, opts)
vim.keymap.set('i', '<C-Del>', function() vim.cmd.normal('dw') end, opts)
vim.keymap.set({'i', 'n'}, '<F2>', vim.cmd.update, opts)
vim.keymap.set({'i', 'n'}, '<F3>', vim.cmd.quit, opts)
vim.keymap.set({'i', 'n'}, '<S-F3>', function() vim.cmd.quit {bang = true} end, opts)
vim.keymap.set({'i'}, '<C-Left>', function() vim.cmd.normal('b') end, opts)
vim.keymap.set({'i'}, '<C-Right>', function() vim.cmd.normal('w') end, opts)
vim.keymap.set({'i'}, '<S-Left>', function() vim.cmd.normal('v') end, opts)
vim.keymap.set({'i'}, '<S-Right>', function() vim.cmd.normal('v') end, opts)
