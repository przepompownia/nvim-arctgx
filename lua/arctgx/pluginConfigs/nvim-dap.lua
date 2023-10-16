local dap = require 'dap'
local php = require('arctgx.dap.php')
local widgets = require('dap.ui.widgets')
local base = require('arctgx.base')
local vim = vim
local api = vim.api

dap.adapters.php = {
  type = 'executable',
  command = base.getPluginDir() .. '/bin/dap-adapter-utils',
  args = {'run', 'vscode-php-debug', 'phpDebug'}
}

local bashdbDir = base.getPluginDir() .. '/tools/vscode-bash-debug/'

---@param defaultValue any
---@param promptTemplate string
---@param valueConversionCallback function|nil
---@param completion string|nil
---@return any
local function getInput(defaultValue, promptTemplate, completion, valueConversionCallback)
  local value = vim.fn.input(promptTemplate:format(defaultValue), defaultValue, completion)
  if '' == value then
    return defaultValue
  end

  if nil == valueConversionCallback then
    return value
  end

  return valueConversionCallback(value)
end

local function splitToArgs(input)
  local result = {}
  for param in string.gmatch(input, '%S+') do
    table.insert(result, param)
  end
  return result
end

dap.adapters.bashdb = {
  type = 'executable',
  command = 'node',
  args = {bashdbDir .. 'extension/out/bashDebug.js'}
}

dap.configurations.sh = {
  {
    type = 'bashdb',
    request = 'launch',
    name = 'Launch bash',
    program = function ()
      return getInput(vim.fn.bufname(), 'Executable to debug [%s]: ', 'file')
    end,
    args = function ()
      return getInput('', 'Params [%s]: ', 'file', splitToArgs)
    end,
    env = {},
    pathBash = '/usr/bin/bash',
    pathBashdb = bashdbDir .. 'extension/bashdb_dir/bashdb',
    pathBashdbLib = bashdbDir .. 'extension/bashdb_dir',
    pathCat = 'cat',
    pathMkfifo = 'mkfifo',
    pathPkill = 'pkill',
    cwd = '${workspaceFolder}',
    terminalKind = 'integrated',
  }
}

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function ()
      local defaultValue = '127.0.0.1'
      local value = vim.fn.input(('Host [%s]: '):format(defaultValue), defaultValue)
      if value ~= '' then
        return value
      end
      return defaultValue
    end,
    port = function ()
      local defaultValue = 9004
      local val = tonumber(vim.fn.input(('Port [%s]: '):format(defaultValue), defaultValue))
      if val ~= '' then
        return val
      end
      return defaultValue
    end,
  }
}

--- @param callback function
--- @param config ServerAdapter
dap.adapters.nlua = function (callback, config)
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

vim.fn.sign_define('DapBreakpoint', {text = '●', texthl = 'IdeBreakpointSign', linehl = ''})
vim.fn.sign_define('DapBreakpointCondition', {text = '◆', texthl = 'IdeBreakpointSign', linehl = ''})
vim.fn.sign_define('DapBreakpointRejected', {text = 'R', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = ''})
vim.fn.sign_define('DapLogPoint', {text = 'L', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = ''})
vim.fn.sign_define('DapStopped', {text = '▶', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = 'CursorLine'})

local opts = {silent = true, noremap = true}
vim.keymap.set({'n'}, '<Plug>(ide-debugger-run)', dap.continue, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-step-over)', dap.step_over, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-step-into)', dap.step_into, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-step-out)', dap.step_out, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-toggle-breakpoint)', dap.toggle_breakpoint, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-clear-breakpoints)', dap.clear_breakpoints, opts)
vim.keymap.set(
  {'n'},
  '<Plug>(ide-debugger-toggle-breakpoint-conditional)',
  function () dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  opts
)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-up-frame)', dap.up, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-down-frame)', dap.down, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-run-to-cursor)', dap.run_to_cursor, opts)
vim.keymap.set({'n'}, '<Plug>(ide-debugger-close)', dap.close, opts)
vim.keymap.set(
  {'n'},
  '<Plug>(ide-debugger-clean)',
  function ()
    dap.close()
    dap.clear_breakpoints()
    api.nvim_exec_autocmds('User', {pattern = 'DAPClean', modeline = false})
  end,
  opts
)
vim.keymap.set(
  {'n'},
  '<Plug>(ide-debugger-add-log-breakpoint)',
  function () dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  opts
)
-- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
dap.defaults.fallback.switchbuf = 'uselast'
dap.defaults.fallback.external_terminal = {
  command = '/usr/bin/kitty',
}
dap.configurations.php = {php.default}
local ideDAPSessionActive = ''

dap.listeners.after['event_initialized']['arctgx'] = function (_session, _body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  ideDAPSessionActive = 'L'
end

dap.listeners.after['event_stopped']['arctgx'] = function (_session, _body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  ideDAPSessionActive = 'S'
end

dap.listeners.after['event_exited']['arctgx'] = function (_session, _body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  print('Exited')
  ideDAPSessionActive = 'E'
end
dap.listeners.after['event_thread']['arctgx'] = function (_session, body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  if body.reason == 'exited' then
    print('Thread ' .. body.threadId .. ' exited')
    ideDAPSessionActive = 'X'
  end
end
dap.listeners.before['disconnect']['arctgx'] = function (_session, _body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  vim.notify('Disconnected')
  ideDAPSessionActive = 'D'
end
dap.listeners.after['event_terminated']['arctgx'] = function (_session, _body)
  api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  vim.notify('Terminated')
  ideDAPSessionActive = 'T'
end

require('arctgx.widgets').addDebugHook(function ()
  return dap.session() and ('⛧' .. ' ' .. ideDAPSessionActive) or '-'
end)
