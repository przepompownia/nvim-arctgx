local keymap = vim.keymap
local api = vim.api
local base = require 'arctgx.base'

local function silentLuaRhsMap(mode, lhs, rhs, opts)
  if type(rhs) ~= 'function' then
    keymap.set(mode, lhs, rhs, opts)
    return
  end
  local silentRhs = function ()
    base.epcall(rhs)
  end
  keymap.set(mode, lhs, silentRhs, opts)
end

local opts = {silent = true}
keymap.set({'n'}, '<Leader>=', 'ggVG=', opts)
keymap.set({'n'}, '<Leader>/', '/', {})
keymap.set({'n'}, '<Leader>?', '?', {})
keymap.set({'n'}, '/', '/\\c', {})
keymap.set({'n'}, '?', '?\\c', {})
keymap.set({'i'}, '<C-q>', '<C-r>+', opts)
keymap.set({'x'}, '<C-Insert>', '"*y', opts)
keymap.set({'x'}, '<C-S-Insert>', '"+y', opts)
keymap.set({'!'}, '<S-Insert>', '<MiddleMouse>', opts)
keymap.set({'n'}, 'g<Left>', '<C-O>', opts)
keymap.set({'n'}, 'g<Right>', '<C-I>', opts)
keymap.set({'i', 'c'}, '<Insert>', '<Nop>', opts)
keymap.set({'i'}, '<C-z>', '<C-x><C-o>', opts)
keymap.set({'n'}, 'Q', '<Nop>', opts)
keymap.set({'c'}, '<C-BS>', '<C-w>', opts)
keymap.set({'c'}, '<C-Del>', '<S-Right><C-w>', opts)
keymap.set({'n'}, '<S-Up>', '<C-y>', opts)
keymap.set({'n'}, '<S-Down>', '<C-e>', opts)
silentLuaRhsMap({'n'}, '<C-w>C', vim.cmd.tabclose, opts)
keymap.set({'n'}, '<C-;>', ':lua ', {})

local function selectionFromPastedRange()
  return '`[' .. vim.fn.getregtype():sub(0, 1) .. '`]'
end

keymap.set('n', 'gp', selectionFromPastedRange, {expr = true, silent = true})
keymap.set('v', ']p', 'pgv=', {silent = true, desc = 'Paste with indentation'})

keymap.set('n', ']p', function ()
  return 'p' .. selectionFromPastedRange() .. '='
end, {expr = true, desc = 'Paste with indentation', silent = true})

keymap.set('n', '<A-j>', function ()
  if vim.fn.line('.') == vim.fn.line('$') then
    return
  end
  return 'ddp' .. selectionFromPastedRange() .. '='
end, {expr = true, desc = 'Move single line down with indentation', silent = true})

keymap.set('v', '<A-j>', function ()
  local max = vim.fn.getpos('.')[2]
  local vline = vim.fn.getpos('v')[2]
  if vline > max then
    max = vline
  end
  if vim.fn.line('$') == max then
    return
  end
  return 'dp' .. selectionFromPastedRange() .. '=gv'
end, {expr = true, desc = 'Move single line down with indentation', silent = true})

keymap.set('n', '<A-k>', function ()
  if api.nvim_win_get_cursor(0)[1] == 1 then
    return
  end
  return 'ddkP' .. selectionFromPastedRange() .. '='
end, {expr = true, desc = 'Move single line up with indentation', silent = true})

keymap.set('v', '<A-k>', function ()
  local min = vim.fn.getpos('.')[2]
  local vline = vim.fn.getpos('v')[2]
  if vline < min then
    min = vline
  end
  if 1 == min then
    return
  end
  return 'dkP' .. selectionFromPastedRange() .. '=gv'
end, {expr = true, desc = 'Move single line up with indentation', silent = true})

local function setreg(register, value)
  vim.fn.setreg(register, value)
  vim.notify(('"%s" copied to reg "%s"'):format(value, register), vim.log.levels.INFO)
end

keymap.set('t', '<S-Insert>', '<C-\\><C-N>"*pi', opts)
keymap.set('n', 'i', function () base.insertWithInitialIndentation('i') end, opts)
keymap.set('n', 'a', function () base.insertWithInitialIndentation('a') end, opts)
keymap.set('n', '<Leader>fcc', function () setreg('+', vim.fn.expand('%:.')) end, opts)
keymap.set('n', '<Leader>fcC', function () setreg('+', vim.fn.expand('%:p')) end, opts)
keymap.set('n', '<Leader>co', vim.cmd.copen, opts)
keymap.set('t', '<M-p>', function ()
  ---@diagnostic disable-next-line: param-type-mismatch
  local regname = vim.fn.nr2char(vim.fn.getchar())
  return vim.keycode(('<C-\\><C-n>"%spi'):format(regname))
end, {silent = true, expr = true})

keymap.set({'i', 'n'}, '<A-Up>', function () vim.cmd.wincmd('k') end, opts)
keymap.set({'i', 'n'}, '<A-Down>', function () vim.cmd.wincmd('j') end, opts)
keymap.set({'i', 'n'}, '<A-Left>', function () vim.cmd.wincmd('h') end, opts)
keymap.set({'i', 'n'}, '<A-Right>', function () vim.cmd.wincmd('l') end, opts)
keymap.set('i', '<C-BS>', '<C-w>', opts)
keymap.set('i', '<C-Del>', function () vim.cmd.normal('dw') end, opts)
silentLuaRhsMap({'i', 'n', 'x'}, '<F2>', vim.cmd.update, opts)
silentLuaRhsMap({'i', 'n', 'x'}, '<F3>', vim.cmd.quit, opts)
silentLuaRhsMap({'i', 'n'}, '<S-F3>', function () vim.cmd.quit {bang = true} end, opts)
silentLuaRhsMap({'i', 'n'}, '<F15>', function () vim.cmd.quit {bang = true} end, opts)
keymap.set({'i'}, '<C-Left>', function () vim.cmd.normal('b') end, opts)
keymap.set({'i'}, '<C-Right>', function ()
  vim._with({wo = {virtualedit = 'onemore'}}, function ()
    vim.cmd.normal('w')
  end)
end, opts)

silentLuaRhsMap('n', '<Esc>', vim.cmd.fclose, {desc = 'Close float window'})

for _, lhs in ipairs({'<C-/>', '<C-_>'}) do
  keymap.set({'n', 'i'}, lhs, function ()
    vim.cmd.normal 'gccj'
  end)

  keymap.set('x', lhs, function ()
    vim.cmd.normal 'gc'
  end)
end
