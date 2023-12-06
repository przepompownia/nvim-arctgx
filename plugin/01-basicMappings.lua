local base = require 'arctgx.base'
local api = vim.api

local opts = {silent = true}
vim.keymap.set({'n'}, '<Leader>=', 'ggVG=', opts)
vim.keymap.set({'n'}, '<Leader>/', '/', {})
vim.keymap.set({'n'}, '<Leader>?', '?', {})
vim.keymap.set({'n'}, '/', '/\\c', {})
vim.keymap.set({'n'}, '?', '?\\c', {})
vim.keymap.set({'i'}, '<C-q>', '<C-r>+', opts)
vim.keymap.set({'x'}, '<C-Insert>', '"*y', opts)
vim.keymap.set({'x'}, '<C-S-Insert>', '"+y', opts)
vim.keymap.set({'!'}, '<S-Insert>', '<MiddleMouse>', opts)
vim.keymap.set({'n', 'v'}, '<Tab>', '<C-w>w', opts)
vim.keymap.set({'n'}, 'g<Left>', '<C-O>', opts)
vim.keymap.set({'n'}, 'g<Right>', '<C-I>', opts)
vim.keymap.set({'i', 'c'}, '<Insert>', '<Nop>', opts)
vim.keymap.set({'i'}, '<C-z>', '<C-x><C-o>', opts)
vim.keymap.set({'n'}, 'Q', '<Nop>', opts)
vim.keymap.set({'c'}, '<C-BS>', '<C-w>', opts)
vim.keymap.set({'c'}, '<C-Del>', '<S-Right><C-w>', opts)
vim.keymap.set({'n'}, '<S-Up>', '<C-y>', opts)
vim.keymap.set({'n'}, '<S-Down>', '<C-e>', opts)

local function selectionFromPastedRange()
  return '`[' .. vim.fn.getregtype():sub(0, 1) .. '`]'
end

vim.keymap.set('n', 'gp', selectionFromPastedRange, {expr = true, silent = true})
vim.keymap.set('v', ']p', 'pgv=', {silent = true, desc = 'Paste with indentation'})

vim.keymap.set('n', ']p', function ()
  return 'p' .. selectionFromPastedRange() .. '='
end, {expr = true, desc = 'Paste with indentation', silent = true})

vim.keymap.set('n', '<A-j>', function ()
  if vim.fn.line('.') == vim.fn.line('$') then
    return
  end
  return 'ddp' .. selectionFromPastedRange() .. '='
end, {expr = true, desc = 'Move single line down with indentation', silent = true})
vim.keymap.set('v', '<A-j>', function ()
  local max = math.max(vim.fn.getpos('v')[2], vim.fn.getpos('.')[2])
  if vim.fn.line('$') == max then
    return
  end
  return 'dp' .. selectionFromPastedRange() .. '=gv'
end, {expr = true, desc = 'Move single line down with indentation', silent = true})

vim.keymap.set('n', '<A-k>', function ()
  if vim.api.nvim_win_get_cursor(0)[1] == 1 then
    return
  end
  return 'ddkP' .. selectionFromPastedRange() .. '='
end, {expr = true, desc = 'Move single line up with indentation', silent = true})

vim.keymap.set('v', '<A-k>', function ()
  local min = math.min(vim.fn.getpos('v')[2], vim.fn.getpos('.')[2])
  if 1 == min then
    return
  end
  return 'dkP' .. selectionFromPastedRange() .. '=gv'
end, {expr = true, desc = 'Move single line up with indentation', silent = true})

vim.keymap.set('t', '<S-Insert>', '<C-\\><C-N>"*pi', opts)
vim.keymap.set('n', 'i', function () base.insertWithInitialIndentation('i') end, opts)
vim.keymap.set('n', 'a', function () base.insertWithInitialIndentation('a') end, opts)
vim.keymap.set('n', '<Leader>fcc', function () vim.fn.setreg('+', vim.fn.expand('%:.')) end, opts)
vim.keymap.set('n', '<Leader>fcC', function () vim.fn.setreg('+', vim.fn.expand('%:p')) end, opts)
vim.keymap.set('n', '<Leader>co', vim.cmd.copen, opts)
vim.keymap.set('t', '<M-p>', function ()
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

vim.keymap.set({'i', 'n'}, '<A-Up>', function () vim.cmd.wincmd('k') end, opts)
vim.keymap.set({'i', 'n'}, '<A-Down>', function () vim.cmd.wincmd('j') end, opts)
vim.keymap.set({'i', 'n'}, '<A-Left>', function () vim.cmd.wincmd('h') end, opts)
vim.keymap.set({'i', 'n'}, '<A-Right>', function () vim.cmd.wincmd('l') end, opts)
vim.keymap.set('i', '<C-BS>', function () vim.cmd.normal('db') end, opts)
vim.keymap.set('i', '<C-Del>', function () vim.cmd.normal('dw') end, opts)
vim.keymap.set({'i', 'n'}, '<F2>', vim.cmd.update, opts)
vim.keymap.set({'i', 'n'}, '<F3>', vim.cmd.quit, opts)
vim.keymap.set({'i', 'n'}, '<S-F3>', function () vim.cmd.quit {bang = true} end, opts)
vim.keymap.set({'i'}, '<C-Left>', function () vim.cmd.normal('b') end, opts)
vim.keymap.set({'i'}, '<C-Right>', function () vim.cmd.normal('w') end, opts)
vim.keymap.set({'i'}, '<S-Left>', function () vim.cmd.normal('v') end, opts)
vim.keymap.set({'i'}, '<S-Right>', function () vim.cmd.normal('v') end, opts)
