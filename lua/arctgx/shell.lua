local Shell = {}

---@param opts {cmd: string[], cwd: string}
function Shell.open(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
  vim.cmd.new({mods = {split = 'botright'}})
  vim.fn.termopen(
    opts.cmd or vim.opt.shell:get(),
    {
      cwd = cwd,
    }
  )
end

return Shell
