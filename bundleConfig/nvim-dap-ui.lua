local api = vim.api
local keymap = require 'vim.keymap'
local dapui = require('dapui')

api.nvim_create_augroup('ArctgxDapUi', { clear = true })
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
  group = 'ArctgxDapUi',
  callback = reloadColors,
})

local opts = {silent = true, noremap = true}
keymap.set({'n'}, '<Plug>(ide-debugger-ui-toggle)', dapui.toggle, opts)
keymap.set({'x'}, '<Plug>(ide-debugger-eval-popup)', function() dapui.eval(nil, {enter = true, context = 'repl'}) end, opts)

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
