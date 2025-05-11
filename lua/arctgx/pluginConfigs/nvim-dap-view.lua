local api = vim.api
local keymap = require('arctgx.vim.abstractKeymap')

require('arctgx.lazy').setupOnLoad('dap', function ()
  local dv = require('dap-view')
  local dap = require('dap')
  local augroup = api.nvim_create_augroup('arctgx.dap-view', {clear = true})

  dap.defaults.fallback.switchbuf = 'useopen'
  dv.setup({
    switchbuf = 'uselast',
    help = {border = 'single'},
    windows = {
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

  api.nvim_create_autocmd({'FileType'}, {
    pattern = filetypes,
    group = augroup,
    callback = function (event)
      keymap.set(
        {'n'},
        'debuggerOpenViewScopes',
        function () dv.jump_to_view('scopes') end,
        {buffer = event.buf}
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewBreakpoints',
        function () dv.jump_to_view('breakpoints') end,
        {buffer = event.buf}
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewExceptions',
        function () dv.jump_to_view('exceptions') end,
        {buffer = event.buf}
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewThreads',
        function () dv.jump_to_view('threads') end,
        {buffer = event.buf}
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewWatches',
        function () dv.jump_to_view('watches') end,
        {buffer = event.buf}
      )
      keymap.set(
        {'n'},
        'debuggerOpenViewREPL',
        function () dv.jump_to_view('repl') end,
        {buffer = event.buf}
      )
    end
  })
end)
