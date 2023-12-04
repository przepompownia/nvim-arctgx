local api = vim.api
local dapui = require('dapui')
local base = require('arctgx.base')
local keymap = require('arctgx.vim.abstractKeymap')

local augroup = api.nvim_create_augroup('ArctgxDapUi', { clear = true })
local function reloadColors()
  local highlights = {
    DapUIVariable = {link = 'Normal'},
    DapUIValue = {link = 'Normal'},
    DapUIFrameName = {link = 'Normal'},
    DapUIBreakpointsLine = {link = 'DapUILineNumber'},
    DapUIScope = {fg = '#455284'},
    DapUIType = {fg = '#456519'},
    DapUIModifiedValue = {fg = '#455284'},
    DapUIDecoration = {fg = '#455284'},
    DapUIThread = {fg = '#A9FF68'},
    DapUIStoppedThread = {fg = '#455284'},
    DapUISource = {fg = '#3E6B00'},
    DapUILineNumber = {fg = '#455284'},
    DapUIFloatBorder = {fg = '#455284'},
    DapUIWatchesEmpty = {fg = '#666666'},
    DapUIWatchesValue = {fg = '#A9FF68'},
    DapUIWatchesError = {fg = '#8E2E28'},
    DapUIBreakpointsPath = {fg = '#455284'},
    DapUIBreakpointsInfo = {fg = '#A9FF68'},
    DapUIBreakpointsCurrentLine = {fg = '#A9FF68', bold = 1},
  }

  for name, def in pairs(highlights) do
    api.nvim_set_hl(0, name, def)
  end
end

api.nvim_create_autocmd({'ColorScheme'}, {
  group = augroup,
  callback = reloadColors,
})

local function watchExpression(expression)
  dapui.elements.watches.add(expression)
end

api.nvim_create_user_command('DAW', function (opts)
  watchExpression(opts.args)
end , {nargs = 1, desc = 'DAP UI: add expression to watch'})

local opts = {silent = true, noremap = true}
keymap.set('x', 'debuggerAddToWatched', function ()
  watchExpression(base.getVisualSelection())
end)
keymap.set({'n'}, 'debuggerUIToggle', dapui.toggle, opts)
keymap.set({'n', 'x'}, 'debuggerEvalToFloat', function ()
  local keywordChars = {}
  if vim.tbl_contains({'php', 'sh'}, vim.bo.ft) then
    keywordChars = {'$'}
  end
  base.withAppendedToKeyword(keywordChars, function ()
    dapui.eval(nil, {enter = true, context = 'repl'})
  end)
end, opts)

dapui.setup({
  mappings = {
    expand = { '<Right>' },
    open = { '<CR>', '<2-LeftMouse>' },
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        { id = 'watches', size = 0.25 },
        { id = 'stacks', size = 0.25 },
        { id = 'breakpoints', size = 0.25 },
      },
      size = 40,
      position = 'left',
    },
    {
      elements = { 'repl' },
      size = 10,
      position = 'bottom',
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = 'single',
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
})
