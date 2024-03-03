local nord = require('lualine.themes.nord')
local ns = require('arctgx.lsp').ns()

vim.api.nvim_set_hl(ns, 'DebugWidgetInactive', {bg = nord.normal.c.bg, fg = nord.normal.c.fg})
vim.api.nvim_set_hl(ns, 'DebugWidgetActive', {bg = nord.normal.c.bg, fg = '#bb0000'})

require('lualine').setup({
  extensions = {
    'man',
    'nvim-tree',
    'quickfix',
    'nvim-dap-ui',
  },
  options = {
    component_separators = {left = '', right = ''},
    disabled_filetypes = {
      'dap-repl',
      'gitcommit',
      'noice',
    },
  },
  sections = {
    lualine_b = {
      {
        'branch',
        on_click = function (_numberOfClicks, button, _modifiers)
          if 'r' == button then
            require('git-utils').branches()
          end
        end
      },
      'diff',
      {
        'diagnostics',
        on_click = function (_numberOfClicks, button, _modifiers)
          if 'l' == button then
            vim.diagnostic.setloclist()
          end
        end
      },
    },
    lualine_c = {
      {
        'filename',
        -- modification mark
        -- fmt = formatFilename,
      },
      {
        'searchcount',
        maxcount = 999,
        timeout = 500,
      },
      {
        'selectioncount',
      },
    },
    lualine_x = {
      function ()
        if not vim.v.this_session then
          return
        end
        return vim.fn.fnamemodify(vim.v.this_session, ':t:r')
      end,
      'encoding',
      'fileformat',
      'filetype',
    },
    lualine_y = {'progress'},
    lualine_z = {
      'location',
      {
        function ()
          return require('arctgx.widgets').renderDebug({
            active = 'DebugWidgetActive',
            inactive = 'DebugWidgetInactive',
            fallback = 'lualine_z_4_normal',
          })
        end,
        separator = {
          left = '',
        },
      },
    },
  },
})
