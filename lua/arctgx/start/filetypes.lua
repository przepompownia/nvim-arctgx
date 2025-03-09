local api = vim.api

local augroup = api.nvim_create_augroup('arctgx.filetypes', {clear = true})

api.nvim_create_autocmd({'FileType'}, {
  pattern = 'help',
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
