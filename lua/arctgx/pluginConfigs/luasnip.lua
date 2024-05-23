require('luasnip.loaders.from_vscode').lazy_load({
  paths = {vim.fs.joinpath(require('arctgx.base').getPluginDir(), 'snippets')},
  include = {'php', 'lua'},
})

local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local events = require('luasnip.util.events')

vim.api.nvim_create_user_command('LuaSnipEdit', function() require('luasnip.loaders').edit_snippet_files() end, {nargs = 0})

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
  s(
    {
      trig = '<<<',
      dscr = 'Heredoc',
    },
    {
      t('<<<'),
      i(1, 'SQL'),
      t({'', ''}),
      i(0),
      t({'', ''}),
      d(2, function (args)
        local eol = args[1] and args[1][1] or 'SQL'
        return sn(nil, {
          t(eol)
        })
      end, {1}),
    }
  ),
})
