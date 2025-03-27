local api = vim.api

local base = require('arctgx.base')
local keymap = require('arctgx.vim.abstractKeymap')

local augroup = api.nvim_create_augroup('ArctgxDapUi', {clear = true})
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

local config = {
  mappings = {
    expand = {'<Right>'},
    open = {'<CR>', '<2-LeftMouse>'},
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  layouts = {
    {
      elements = {
        {id = 'scopes',      size = 0.25},
        {id = 'watches',     size = 0.25},
        {id = 'stacks',      size = 0.25},
        {id = 'breakpoints', size = 0.25},
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        'repl',
        -- 'console',
      },
      size = 10,
      position = 'bottom',
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = 'rounded',
    mappings = {
      close = {'q', '<Esc>'},
    },
  },
}

api.nvim_create_autocmd({'ColorScheme'}, {
  group = augroup,
  callback = reloadColors,
})

keymap.set({'n'}, 'debuggerUIToggle', function () require('dapui').toggle() end)

local function watchExpression(expression)
  require('dapui').elements.watches.add(expression)
end

api.nvim_create_user_command('DAW', function (opts)
  watchExpression(opts.args)
end, {nargs = 1, desc = 'DAP UI: add expression to watch'})

api.nvim_create_autocmd({'FileType'}, {
  pattern = vim.tbl_keys(require('arctgx.dap').getDeclaredConfigurations()),
  group = augroup,
  callback = function (event)
    local opts = {silent = true, buffer = event.buf}
    keymap.set('x', 'debuggerAddToWatched', function ()
      watchExpression(base.getVisualSelection())
    end, opts)
    keymap.set('n', 'debuggerAddToWatched', function ()
      watchExpression(vim.fn.expand('<cexpr>'))
    end, opts)
    keymap.set({'n', 'x'}, 'debuggerEvalToFloat', function ()
      require('dapui').eval(nil, {enter = true, context = 'repl'})
    end, opts)
  end
})

require('arctgx.lazy').setupOnLoad('dapui', function ()
  require('dapui').setup(config)

  api.nvim_create_autocmd({'FileType'}, {
    pattern = {'dapui_scopes'},
    group = augroup,
    callback = function ()
      local tabpage = api.nvim_get_current_tabpage()
      vim.t[tabpage].arctgxTabName = 'DAP UI'
    end
  })
end)
