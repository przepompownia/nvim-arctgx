require('nvim-treesitter').setup({})

require('nvim-treesitter.install').install(
  require('nvim-treesitter.config').norm_languages(require('arctgx.treesitter').langs(), {installed = true}),
  {},
  function ()
    vim.api.nvim_exec_autocmds('User', {pattern = 'TSInstallFinished'})
  end
)

vim.api.nvim_create_user_command('TSUpdateSync', function (args)
  local okv = 'something never passed to cb'

  local ok = okv

  require('nvim-treesitter.install').update(
    nil,
    nil,
    function (success)
      ok = success
    end
  )

  vim.wait(15000, function ()
    return ok ~= okv
  end)

  if args.args == 'quit' then
    vim.cmd.cquit({count = (ok ~= false) and 0 or 1})
  end
end, {nargs = '?'})
