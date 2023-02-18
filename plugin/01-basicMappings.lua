local keymap = require 'arctgx.vim.keymap'

---@type KeyToPlugMappings
local mapToKeySequenceList = {
  ['<Leader>='] = {rhs = '<Leader>=', modes = {'n', 'v'}},
  ['<Leader>/'] = {rhs = '/', modes = {'n'}},
  ['<Leader>?'] = {rhs = '?', modes = {'n'}},
  ['/'] = {rhs = '/\\c', modes = {'n'}},
  ['?'] = {rhs = '?\\c', modes = {'n'}},
  ['<C-q>'] = {rhs = '<C-r>+', modes = {'i'}},
  ['<C-Insert>'] = {rhs = '"*y', modes = {'x'}},
  ['<C-S-Insert>'] = {rhs = '"+y', modes = {'x'}},
  ['<S-Insert>'] = {rhs = '<MiddleMouse>', modes = {'!'}},
  ['<S-Insert>'] = {rhs = '<MiddleMouse>', modes = {'c'}},
  ['<S-Insert>'] = {rhs = '<C-\\><C-N>"*pi', modes = {'c'}},
  ['<Tab>'] = {rhs = '<C-w>w', modes = {'n', 'v'}},
  ['g<Left>'] = {rhs = '<C-O>', modes = {'n'}},
  ['g<Right>'] = {rhs = '<C-I>', modes = {'n'}},
  ['<Insert>'] = {rhs = '<Nop>', modes = {'i'}},
  ['Q'] = {rhs = '<Nop>', modes = {'n'}},
  ['<C-BS>'] = {rhs = '<C-w>', modes = {'c'}},
  ['<C-Del>'] = {rhs = '<S-Right><C-w>', modes = {'c'}},
  ['<S-Up>'] = {rhs = '<C-y>', modes = {'n'}},
  ['<S-Down>'] = {rhs = '<C-e>', modes = {'n'}},
}
keymap.loadKeyToPlugMappings(mapToKeySequenceList)
