require('lualine').setup({
  tabline = {
    lualine_a = {{
      'tabs',
      mode = 2,
      max_length = vim.o.columns,
      tabs_color = {
        active = function ()
          return {
            fg = '#37660C',
            bg = '#989898',
            -- link =
          }
        end,
      },
      fmt = function (name)
        return name
      end
    }},
  }
})
