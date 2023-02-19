local augroup = vim.api.nvim_create_augroup('terminalMode', {clear = true})
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup,
  pattern = 'term://*',
  callback = function ()
    vim.opt_local.number = false
    vim.cmd.startinsert()
  end
})
vim.api.nvim_create_autocmd('TermClose', {
  group = augroup,
  pattern = 'term://*',
  callback = function ()
    vim.cmd.quit()
  end
})

vim.api.nvim_create_user_command('Shell', function ()
  local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
  vim.notify(cwd)
  vim.cmd.new({mods = {split = 'botright'}})
  vim.fn.termopen(
    vim.opt.shell:get(),
    {
      cwd = cwd,
    }
  )
end, {})
