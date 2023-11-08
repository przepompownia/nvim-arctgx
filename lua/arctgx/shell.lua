local Shell = {}

---@param opts {cmd: string[], cwd: string}
function Shell.open(opts)
  opts = opts or {}
  vim.validate({cmd = {opts.cmd, {'table', 'string'}}})
  if #opts.cmd == 0 then
    opts.cmd = vim.opt.shell:get()
  end
  local cwd = opts.cwd or require('arctgx.base').getBufferCwd()
  vim.cmd.new({mods = {split = 'botright'}})
  vim.fn.termopen(
    opts.cmd,
    {
      cwd = cwd,
    }
  )
end

return Shell
