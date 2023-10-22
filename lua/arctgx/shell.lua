local Shell = {}

---@param opts {cmd: string[], cwd: string}
function Shell.open(opts)
  opts = opts or {}
  vim.validate({cmd = {opts.cmd, {'table', 'string'}}})
  if #opts.cmd == 0 then
    opts.cmd = vim.opt.shell:get()
  end
  local cwd = opts.cwd or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
  vim.cmd.new({mods = {split = 'botright'}})
  vim.fn.termopen(
    opts.cmd,
    {
      cwd = cwd,
    }
  )
end

return Shell
