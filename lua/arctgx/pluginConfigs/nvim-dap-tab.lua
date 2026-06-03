local api = vim.api

local session = require 'arctgx.session'
local keymap = require('arctgx.vim.abstractKeymap')

local opts = {silent = true}

keymap.set({'n'}, 'debuggerJumpToUI', function () require('dap-tab').verboseGoToDebugWin() end, opts)
keymap.set({'n'}, 'debuggerCloseUI', function () require('dap-tab').closeDebugWin() end, opts)

local augroup = api.nvim_create_augroup('ArctgxDapTab', {clear = true})
api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'DAPClean',
  callback = function () require('dap-tab').closeDebugWin() end,
})

require('arctgx.lazy').setupOnLoad('dap', {
  before = function () vim.cmd.packadd('nvim-dap-tab') end,
  after = function ()
    local dapTab = require('dap-tab')
    local dapViewConfig = require('arctgx.pluginConfigs.nvim-dap-view')
    dapTab.setup({
      uiCallbacks = {
        open = function ()
          dapViewConfig.switchbuf = dapTab.getDebugWinId
        end,
        close = function ()
          dapViewConfig.switchbuf = nil
        end,
      }
    })

    session.appendBeforeSaveHook('dap-tab - close debug window', function () require('dap-tab').closeDebugWin() end)
  end
})
