local base = require('arctgx.base')
local keymap = require('arctgx.vim.abstractKeymap')

local keymapOpts = {silent = true}

require('arctgx.lazy').setupOnLoad('dap', function ()
  local dap = require('dap')
  dap.adapters.php = {
    type = 'executable',
    command = base.getPluginDir() .. '/bin/dap-adapter-utils',
    args = {'run', 'vscode-php-debug', 'phpDebug'}
  }

  local bashdbDir = base.getPluginDir() .. '/tools/vscode-bash-debug/'

  --- @param defaultValue any
  --- @param promptTemplate string
  --- @param valueConversionCallback function|nil
  --- @param completion string|nil
  --- @return any
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
      result[#result+1] = param
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

  dap.configurations.php = {require('arctgx.dap.php').default}

  require('arctgx.dap').compareDeclaredFiletypes(dap.configurations)

  local function toggle_scopes()
    local widgets = require('dap.ui.widgets')
    local scopes = widgets.sidebar(widgets.scopes)
    scopes.toggle()
  end

  local function toggle_frames()
    local widgets = require('dap.ui.widgets')
    local frames = widgets.sidebar(widgets.frames)
    frames.toggle()
  end

  vim.api.nvim_create_user_command('DAPWidgetScopes', toggle_scopes, {})
  vim.api.nvim_create_user_command('DAPWidgetFrames', toggle_frames, {})

  keymap.set({'n'}, 'debuggerStepOver', keymap.repeatable(dap.step_over), {expr = true})
  keymap.set({'n'}, 'debuggerStepInto', keymap.repeatable(dap.step_into), {expr = true})
  keymap.set({'n'}, 'debuggerStepOut', keymap.repeatable(dap.step_out), {expr = true})
  keymap.set({'n'}, 'debuggerFrameUp', keymap.repeatable(dap.up), {expr = true})
  keymap.set({'n'}, 'debuggerFrameDown', keymap.repeatable(dap.down), {expr = true})
  keymap.set({'n'}, 'debuggerRunToCursor', dap.run_to_cursor, keymapOpts)

  local function info(message)
    vim.notify(message, vim.log.levels.INFO, {title = 'DAP'})
  end
  -- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
  -- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
  dap.defaults.fallback.switchbuf = 'uselast'
  dap.defaults.fallback.external_terminal = {
    command = '/usr/bin/kitty',
  }
  local dapSessionStatus = ''

  dap.listeners.after['event_initialized']['arctgx'] = function (_session, _body)
    dapSessionStatus = 'L'
  end

  dap.listeners.after['event_stopped']['arctgx'] = function (_session, _body)
    dapSessionStatus = 'S'
  end

  dap.listeners.after['event_exited']['arctgx'] = function (_session, _body)
    info('Exited')
    dapSessionStatus = 'E'
  end
  dap.listeners.after['event_thread']['arctgx'] = function (_session, body)
    if body.reason == 'exited' then
      info('Thread ' .. body.threadId .. ' exited')
      dapSessionStatus = 'X'
    end
  end
  dap.listeners.before['disconnect']['arctgx'] = function (_session, _body)
    info('Disconnected')
    dapSessionStatus = 'D'
  end
  dap.listeners.after['event_terminated']['arctgx'] = function (_session, _body)
    info('Terminated')
    dapSessionStatus = 'T'
  end

  require('arctgx.widgets').debugHook = function ()
    return {
      session = dap.session() and true or false,
      status = dapSessionStatus,
    }
  end
end)

vim.fn.sign_define('DapBreakpoint', {text = '●', texthl = 'IdeBreakpointSign', linehl = ''})
vim.fn.sign_define('DapBreakpointCondition', {text = '◆', texthl = 'IdeBreakpointSign', linehl = ''})
vim.fn.sign_define('DapBreakpointRejected', {text = 'R', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = ''})
vim.fn.sign_define('DapLogPoint', {text = 'L', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = ''})
vim.fn.sign_define('DapStopped', {text = '▶', texthl = 'IdeCodeWindowCurrentFrameSign', linehl = 'CursorLine'})

local augroup = vim.api.nvim_create_augroup('ArctgxDap', {clear = true})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = require('arctgx.dap').getDeclaredConfigurations(),
  group = augroup,
  callback = function (event)
    keymap.set(
      {'n'},
      'debuggerToggleBreakpoint',
      keymap.repeatable(function () require('dap').toggle_breakpoint() end),
      {expr = true, buffer = event.buf}
    )
    keymap.set(
      {'n'},
      'debuggerSetLogBreakpoint',
      function () require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
      {buffer = event.buf}
    )
  end
})

keymap.set({'n'}, 'debuggerRun', keymap.repeatable(function () require('dap').continue() end), {expr = true})
keymap.set({'n'}, 'debuggerClearBreakpoints', function () require('dap').clear_breakpoints() end, keymapOpts)
keymap.set(
  {'n'},
  'debuggerSetBreakpointConditional',
  function ()
    vim.ui.input({prompt = 'Breakpoint condition: '}, function (condition)
      require('dap').set_breakpoint(condition)
    end)
  end,
  keymapOpts
)
keymap.set({'n'}, 'debuggerClose', function () require('dap').close() end, keymapOpts)
keymap.set(
  {'n'},
  'debuggerClean',
  function ()
    require('dap').close()
    require('dap').clear_breakpoints()
    vim.api.nvim_exec_autocmds('User', {pattern = 'DAPClean', modeline = false})
  end,
  keymapOpts
)
