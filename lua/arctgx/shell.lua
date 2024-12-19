local Shell = {}

--- @param opts {cmd: string|string[], cwd: string}?
function Shell.open(opts)
  opts = opts or {}
  vim.validate('opts', opts, {'table', 'string', 'nil'})
  vim.validate('opts.cmd', opts.cmd, {'table', 'string', 'nil'})
  if not opts.cmd or (#opts.cmd == 0) then
    opts.cmd = vim.go.shell
  end
  local cwd = opts.cwd or require('arctgx.base').getBufferCwd()
  vim.cmd.new({mods = {split = 'botright'}})
  vim.fn.jobstart(
    opts.cmd,
    {
      cwd = cwd,
      term = true,
    }
  )
end

return Shell
