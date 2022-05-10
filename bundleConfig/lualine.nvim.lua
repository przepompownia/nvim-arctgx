require('lualine').setup({
  tabline = {
    lualine_a = {{
      'tabs',
      mode = 2,
      max_length = vim.o.columns,
      fmt = function (name)
        return name
      end
    }},
  }
})
