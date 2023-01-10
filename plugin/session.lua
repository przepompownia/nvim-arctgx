local api = vim.api
local session = require 'arctgx.session'

local function mksessionCmd(opts)
  if false == session.runBeforeSaveHooks() then
    return
  end
  local ok, out = pcall(api.nvim_cmd, {cmd = 'mks', bang = opts.bang, args = opts.fargs}, {})
  if not ok then
    vim.notify(out, vim.log.levels.ERROR)
  end
end

api.nvim_create_user_command('Mks', mksessionCmd, {
  desc = 'Create session',
  force = true,
  nargs = '?',
  bang = true,
})
