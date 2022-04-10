require('luasnip.loaders.from_snipmate').load()

local ls = require"luasnip"
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")

ls.add_snippets('lua', {
  s('lvd', {
    t('print(vim.inspect('),
    i(1),
    t('))'),
  }),
  s('lvt', {
    t('print(debug.traceback())'),
  })
})
