local augroup = vim.api.nvim_create_augroup('terminalMode', {clear = true})
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup,
  pattern = 'term://*',
  callback = function ()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd.startinsert()
  end
})
vim.api.nvim_create_autocmd('TermClose', {
  group = augroup,
  pattern = 'term://*',
  callback = function (args)
    if vim.api.nvim_buf_is_valid(args.buf) then
      vim.api.nvim_buf_delete(args.buf, {})
    end
  end
})

vim.api.nvim_create_user_command('Shell', function (opts)
  require('arctgx.shell').open({cmd = opts.fargs})
end, {nargs = '*'})

require('arctgx.vim.abstractKeymap').set('n', 'shellOpen', function ()
  require('arctgx.shell').open()
end)
