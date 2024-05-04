require('nvim-surround').setup({
  surrounds = {
    f = {
      add = function ()
        if vim.bo.filetype ~= 'lua' then
          return
        end
        return {{'function () '}, {'() end'}}
      end
    }
  }
})
