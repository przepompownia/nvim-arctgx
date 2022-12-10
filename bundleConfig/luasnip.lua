require('luasnip.loaders.from_snipmate').load()
local lsp = require('vim.lsp')

local ls = require 'luasnip'
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local events = require("luasnip.util.events")

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

ls.add_snippets('php', {
  s(
    {
      trig = 'yca',
      dscr = 'Yii web action',
    },
    {
      t('public function action'),
      i(1, 'Index'),
      t('('),
      i(2, 'string'),
      t(' $'),
      i(3, 'slug'),
      t('): '),
      i(4, 'Response'),
      t({'', '{', '}'}),
    },
    {
      callbacks = {
        [4] = {
          [events.leave] = function()
              vim.api.nvim_cmd({cmd = 'stopinsert'}, {})
              lsp.buf.code_action()
          end
        }
      }
    }),
  s(
    {
      trig = 'prc',
      dscr = 'promoted private property',
    },
    {
      t('private '),
      i(1, 'string'),
      t(' $'),
      i(2, 'name'),
      t(',')
    })
})


-- ls.config.set_config({
--   region_check_events = 'InsertEnter',
--   delete_check_events = 'InsertLeave'
-- })
