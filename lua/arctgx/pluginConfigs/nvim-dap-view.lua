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
    help = {border = 'single'},
    windows = {
      size = 0.3,
      terminal = {
        hide = {'php'},
      },
    },
  })
  dap.listeners.after.event_stopped['dap-view-config'] = function ()
    api.nvim_exec_autocmds('FileType', {
      group = augroup,
      pattern = vim.bo.ft,
    })
    dv.open()
  end
  dap.listeners.before.event_terminated['dap-view-config'] = function ()
    dv.close(true)
  end
  dap.listeners.before.event_exited['dap-view-config'] = function ()
    dv.close(true)
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
    end
  })
end)
