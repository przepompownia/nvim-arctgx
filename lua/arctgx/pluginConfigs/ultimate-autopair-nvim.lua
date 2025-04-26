local ua = require('ultimate-autopair')

ua.setup({
  cr = {enable = false},
})

local uaCr = '<Plug>ultimate-autopair-CR'

ua.init({
  ua.extend_default({
    tabout = {
      enable = true,
      map = '<A-CR>',
      cmap = '<A-CR>',
      conf = {},
      multi = false,
      hopout = true,
      do_nothing_if_fail = true,
    },
    cr = {
      map = uaCr,
      conf = {
        cond = function () return true end,
      },
    },
  }),
  {profile = 'map', {'i', uaCr, '\r', p = -1}},
})

require('arctgx.completion').setAutopairCR(function ()
  return vim.api.nvim_feedkeys(vim.keycode('<Plug>ultimate-autopair-CR'), 'n', false)
end)
