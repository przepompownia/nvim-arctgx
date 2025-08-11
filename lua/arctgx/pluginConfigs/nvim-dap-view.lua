local api = vim.api
local base = require('arctgx.base')
local keymap = require('arctgx.vim.abstractKeymap')

require('arctgx.lazy').setupOnLoad('dap-view', function () end, {'dap'})
require('arctgx.lazy').setupOnLoad('dap', function ()
  local dv = require('dap-view')
  local dap = require('dap')
  local augroup = api.nvim_create_augroup('arctgx.dap-view', {clear = true})

  dap.defaults.fallback.switchbuf = 'useopen,uselast'
  dv.setup({
    winbar = {
      default_section = 'scopes',
    },
    switchbuf = 'useopen,uselast',
    help = {border = 'single'},
    windows = {
      height = 0.3,
      terminal = {
        hide = {'php'},
      },
    },
  })
  dap.listeners.before.event_stopped['dap-view-config'] = function ()
    api.nvim_exec_autocmds('FileType', {
      group = augroup,
      pattern = vim.bo.ft,
    })
    dv.open()
  end
  dap.listeners.before.event_terminated['dap-view-config'] = function ()
    dv.close()
  end
  dap.listeners.before.event_exited['dap-view-config'] = function ()
    dv.close()
  end

  api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = 'DAPClean',
    callback = function () dv.close() end,
  })

  local filetypes = vim.tbl_keys(require('arctgx.dap').getDeclaredConfigurations())
  filetypes[#filetypes + 1] = 'dap-view'

  local function watchExpression(expression)
    require('dap-view').add_expr(expression)
  end

  api.nvim_create_user_command('DAW', function (opts)
    watchExpression(opts.args)
  end, {nargs = 1, desc = 'dap-view: add expression to watch'})

  api.nvim_create_autocmd({'FileType'}, {
    pattern = filetypes,
    group = augroup,
    callback = function (event)
      local opts = {silent = true, buffer = event.buf}
      keymap.set('x', 'debuggerAddToWatched', function ()
        watchExpression(base.getVisualSelection())
      end, opts)
      keymap.set('n', 'debuggerAddToWatched', function ()
        watchExpression(vim.fn.expand('<cexpr>'))
      end, opts)
      keymap.set(
        {'n'},
        'debuggerOpenViewScopes',
        function () dv.jump_to_view('scopes') end,
        opts
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewBreakpoints',
        function () dv.jump_to_view('breakpoints') end,
        opts
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewExceptions',
        function () dv.jump_to_view('exceptions') end,
        opts
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewThreads',
        function () dv.jump_to_view('threads') end,
        opts
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewWatches',
        function () dv.jump_to_view('watches') end,
        opts
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewREPL',
        function () dv.jump_to_view('repl') end,
        opts
      )
    end
  })
end)
