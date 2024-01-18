require('luasnip.loaders.from_snipmate').load()

local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node
local events = require('luasnip.util.events')

ls.add_snippets('lua', {
  s('lvd', {
    t('print(vim.inspect('),
    i(1),
    t('))'),
  }),
  s('lvt', {
    t('print(debug.traceback())'),
  }),
  s('finish', {
    t('if true then return end'),
  }),
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
          [events.leave] = function ()
            vim.api.nvim_cmd({cmd = 'stopinsert'}, {})
            vim.lsp.buf.code_action()
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
      c(1, {
        t 'private ',
        t 'public ',
      }),
      i(2, 'readonly '),
      i(3, 'string'),
      t(' $'),
      d(4, function (args)
        local type = args[1] and args[1][1] or 'name'
        local lcfirst = type:gsub('^%u', string.lower)
        return sn(nil, {
          i(1, lcfirst)
        })
      end, {3}),
      t(',')
    }),
})


-- ls.config.set_config({
--   region_check_events = 'InsertEnter',
--   delete_check_events = 'InsertLeave'
-- })
