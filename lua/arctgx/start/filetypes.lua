local api = vim.api

local augroup = api.nvim_create_augroup('arctgx.filetypes', {clear = true})

api.nvim_create_autocmd({'FileType'}, {
  pattern = {'help', 'man'},
  group = augroup,
  nested = true,
  callback = function ()
    if vim.opt_local.buftype:get() ~= 'help' then
      return
    end

    vim.keymap.set({'n'}, 'q', function ()
      vim.api.nvim_buf_delete(0, {})
    end, {buffer = 0})

    vim.cmd([[silent wincmd T]])
  end
})

api.nvim_create_autocmd({'FileType'}, {
  pattern = {'sql', 'mysql'},
  group = augroup,
  nested = true,
  callback = function (ev)
    vim.opt_local.isfname:append('`')
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    vim.g.loaded_sql_completion = 1
    vim.g.omni_sql_no_default_maps = 1
    vim.g.ftplugin_sql_omni_key = '<Nop>'
    vim.keymap.set({'n', 'i', 'v'}, '<F2>', vim.cmd.write, {buffer = ev.buf, desc = 'Write SQL query'})
  end
})
