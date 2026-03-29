-- From Neovim test utils.
-- Extracted here while not exposed as public on the Nvim side
-- https://github.com/neovim/neovim/blob/3e843a2891258c1a297daa97e9704d9bf110b760/test/functional/plugin/lsp/testutil.lua#L68-L119

local function createServer(opts)
  opts = opts or {}
  local server = {}
  server.messages = {}

  function server.cmd(dispatchers)
    local closing = false
    local handlers = opts.handlers or {}
    local srv = {}

    function srv.request(method, params, callback)
      table.insert(server.messages, {
        method = method,
        params = params,
      })
      local handler = handlers[method]
      if handler then
        handler(method, params, callback)
      elseif method == 'initialize' then
        callback(nil, {
          capabilities = opts.capabilities or {},
        })
      elseif method == 'shutdown' then
        callback(nil, nil)
      end
      local request_id = #server.messages
      return true, request_id
    end

    function srv.notify(method, params)
      table.insert(server.messages, {
        method = method,
        params = params,
      })
      if method == 'exit' then
        dispatchers.on_exit(0, 15)
      end
    end

    function srv.is_closing()
      return closing
    end

    function srv.terminate()
      closing = true
    end

    return srv
  end

  return server
end

return setmetatable({}, {
  __call = function (_, opts)
    return createServer(opts)
  end,
})
