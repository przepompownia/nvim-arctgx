require('flatten').setup({
  callbacks = {
    post_open = function (bufnr, _winnr, ft, _is_blocking)
      if ft == 'gitcommit' or ft == 'gitrebase' then
        vim.schedule(vim.cmd.startinsert)
        vim.api.nvim_create_autocmd({'QuitPre'}, {
          buffer = bufnr,
          once = true,
          callback = vim.schedule_wrap(function ()
            vim.api.nvim_buf_delete(bufnr, {})
          end),
        })
      end
    end,
  }
})
