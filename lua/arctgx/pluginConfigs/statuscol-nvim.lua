local builtin = require('statuscol.builtin')
local dc = require('arctgx.dap').getDeclaredConfigurations()

local function lnumClick(args)
  if args.button ~= 'l' or dc[vim.bo.filetype] ~= nil then
    return builtin.lnum_click(args)
  end
end

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
      sign = {namespace = {'.*.diagnostic.signs'}, maxwidth = 1, colwidth = 2, auto = true, foldclosed = true},
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
    -- {text = {'%{&nu?v:lnum:""}', ' '}, click = 'v:lua.ScLa'},
    {text = {builtin.lnumfunc, ' '}, click = 'v:lua.ScLa'},
  },
  ft_ignore = {
    'NvimTree',
  },
  clickhandlers = {
    Lnum = lnumClick,
  },
})
