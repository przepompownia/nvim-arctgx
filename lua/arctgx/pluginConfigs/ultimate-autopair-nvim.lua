local ua = require('ultimate-autopair')

ua.setup({
  cr = {enable = false}
})

local uaCr = '<Plug>ultimate-autopair-CR'
local uaCrV = vim.api.nvim_replace_termcodes(uaCr, true, true, true)

ua.init {ua.extend_default {
  cr = {map = uaCr}
}, {profile = 'map', {'i', uaCr, '\r', p = -1}}}

require('arctgx.completion').setAutopairCR(function ()
  return vim.api.nvim_feedkeys(uaCrV, 'n', false)
end)
