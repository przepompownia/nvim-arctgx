require('trevj').setup({
  containers = {
    php = {
      table_constructor = {final_separator = ',', final_end_line = true},
      arguments = {final_separator = true, final_end_line = true},
      parameters = {final_separator = true, final_end_line = true},
    },
  },
})
