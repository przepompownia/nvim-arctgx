local dap = require 'dap'
local dapui = require 'dapui'
local keymap = require 'vim.keymap'
local php = require('arctgx.dap.php')
local widgets = require('dap.ui.widgets')
local vim = vim
local api = vim.api

dap.adapters.php = {
  type = 'executable',
  command = vim.fn['arctgx#arctgx#getInitialVimDirectory']() .. '/bin/vscode-php-debug',
  args = { 'run' }
}

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local defaultValue = '127.0.0.1'
      local value = vim.fn.input(('Host [%s]: '):format(defaultValue), defaultValue)
      if value ~= '' then
        return value
      end
      return defaultValue
    end,
    port = function()
      local defaultValue = 9004
      local val = tonumber(vim.fn.input(('Port [%s]: '):format(defaultValue), defaultValue))
      if val~= '' then
        return val
      end
      return defaultValue
    end,
  }
}

dap.adapters.nlua = function(callback, config)
  callback({type = 'server', host = config.host, port = config.port})
end

local function toggle_scopes()
  local scopes = widgets.sidebar(widgets.scopes)
  scopes.toggle()
end

local function toggle_frames()
  local frames = widgets.sidebar(widgets.frames)
  frames.toggle()
end

vim.api.nvim_create_user_command('DAPWidgetScopes', toggle_scopes, {})
vim.api.nvim_create_user_command('DAPWidgetFrames', toggle_frames, {})

vim.fn.sign_define('DapBreakpoint', {text = '●', texthl = 'IdeBreakpointSign', linehl = '', numhl = 'IdeBreakpointLineNr'})
vim.fn.sign_define('DapBreakpointCondition', {text = '◆', texthl = 'IdeBreakpointSign', linehl = '', numhl = 'IdeBreakpointLineNr'})
vim.fn.sign_define('DapBreakpointRejected', {text = 'R', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = '', numhl = 'IdeBreakpointLineNr'})
vim.fn.sign_define('DapLogPoint', {text = 'L', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = '', numhl = 'IdeBreakpointLineNr'})
vim.fn.sign_define('DapStopped', {text = '▶', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = 'CursorLine', numhl = ''})

local opts = {silent = true, noremap = true}
keymap.set({'n'}, '<Plug>(ide-debugger-run)', function ()
  dap.continue()
  vim.cmd([[silent! call repeat#set("\<Plug>(ide-debugger-run)", -1)]])
end, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-step-over)', function()
  dap.step_over()
  vim.cmd([[silent! call repeat#set("\<Plug>(ide-debugger-step-over)", -1)]])
end, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-step-into)', dap.step_into, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-step-out)', dap.step_out, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-toggle-breakpoint)', dap.toggle_breakpoint, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-clear-breakpoints)', dap.clear_breakpoints, opts)
keymap.set(
  {'n'},
  '<Plug>(ide-debugger-toggle-breakpoint-conditional)',
  function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  opts
)
keymap.set({'n'}, '<Plug>(ide-debugger-up-frame)', dap.up, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-down-frame)', dap.down, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-run-to-cursor)', dap.run_to_cursor, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-close)', dap.close, opts)
keymap.set(
  {'n'},
  '<Plug>(ide-debugger-add-log-breakpoint)',
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  opts
)
-- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
dap.configurations.php = {php.default}
local ideDAPSessionActive = ''

dap.listeners.after['event_initialized']['arctgx'] = function(session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  ideDAPSessionActive = 'L'
end

dap.listeners.after['event_stopped']['arctgx'] = function(session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  ideDAPSessionActive = 'S'
end

dap.listeners.after['event_exited']['arctgx'] = function(session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  print('Exited')
  ideDAPSessionActive = 'E'
end
dap.listeners.after['event_thread']['arctgx'] = function(session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  if body.reason == 'exited' then
    print('Thread ' .. body.threadId .. ' exited')
    ideDAPSessionActive = 'X'
  end
end
dap.listeners.before['disconnect']['arctgx'] = function(session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  vim.notify('Disconnected')
  ideDAPSessionActive = 'D'
end
dap.listeners.after['event_terminated']['arctgx'] = function(session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  vim.notify('Terminated')
  ideDAPSessionActive = 'T'
end

local debugWinId = nil

local function goToDebugWin()
  if nil ~= debugWinId and api.nvim_win_is_valid(debugWinId) then
    api.nvim_set_current_win(debugWinId)

    return true
  end
end

local function verboseGoToDebugWin()
  if goToDebugWin() then
    return
  end

  vim.notify('Debug window is not defined yet.')
end

local function closeDebugWin()
  if nil == debugWinId then
    return
  end
  local tabNr = api.nvim_tabpage_get_number(api.nvim_win_get_tabpage(debugWinId))
  dapui.close()
  vim.cmd('tabclose ' .. tabNr)
end

local function openTabForThread()
  if goToDebugWin() then
    return
  end

  vim.cmd([[
    tabedit %
    setlocal scrolloff=10
  ]])
  debugWinId = vim.fn.win_getid()
  dapui.open()
end

dap.listeners.before['event_stopped']['arctgx-dap-tab'] = function()
  openTabForThread()
end

keymap.set({'n'}, '<Plug>(ide-debugger-go-to-view)', verboseGoToDebugWin, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-close-view)', closeDebugWin, opts)

require('arctgx.widgets').addDebugHook(function ()
  return dap.session() and ('⛧' ..  ' ' .. ideDAPSessionActive) or '-'
end)
