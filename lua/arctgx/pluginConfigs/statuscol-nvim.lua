local builtin = require('statuscol.builtin')
require('statuscol').setup({
  relculright = true,
  segments = {
    {
      text = {builtin.foldfunc},
      condition = {true},
      click = 'v:lua.ScFa',
    },
    {
      sign = {namespace = {'gitsigns*'}, maxwidth = 1, colwidth = 1, auto = true},
      click = 'v:lua.ScSa',
    },
    {
      sign = {namespace = {'.*/diagnostic/signs'}, maxwidth = 1, colwidth = 2, auto = true, foldclosed = true},
      click = 'v:lua.ScSa'
    },
    {
      sign = {name = {'Dap.*'}, maxwidth = 2, colwidth = 2, auto = true},
      click = 'v:lua.ScLa'
    },
    {
      sign = {name = {'.*'}, maxwidth = 1, colwidth = 1, auto = true},
      click = 'v:lua.ScSa'
    },
    {text = {builtin.lnumfunc, ' '}, click = 'v:lua.ScLa',},
  },
  ft_ignore = {
    'NvimTree',
  },
})
