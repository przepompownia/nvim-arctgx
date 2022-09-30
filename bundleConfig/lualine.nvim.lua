local widgets = require "arctgx.widgets"
local arctgxString = require('arctgx.string')
local telescope = require('arctgx.telescope')

local function formatFilename(name)
  name = name:gsub('[.][^.]+$', '')

  return arctgxString.shorten(name, 8)
end

local debugWidgetLength = 4

require('lualine').setup({
  options = {
    disabled_filetypes = {
      'fern',
      'dap-repl',
    },
  },
  sections = {
    lualine_b = {
      {
        'branch',
        on_click = function (numberOfClicks, button, modifiers)
          if 'r' == button then
            telescope.branches()
          end
        end
      },
      'diff',
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        -- modification mark
        -- fmt = formatFilename,
      }
    },
  },
  -- inactive_sections = {
  -- },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        max_length = function ()
          return vim.o.columns - debugWidgetLength - 1
        end,
        tabs_color = {
          inactive = function ()
            return {
              fg = '#888888',
              bg = '#bebebe',
              gui = 'bold',
              -- link =
            }
          end,
          active = function ()
            return {
              fg = '#a7a7a7',
              bg = '#ffffff',
              gui = 'bold',
              -- link =
            }
          end,
        },
        fmt = formatFilename,
      },
    },
    lualine_z = {
      {
        widgets.renderDebug,
        max_length = debugWidgetLength,
      },
    }
  }
})

vim.api.nvim_create_augroup('ArctgxLualine', {clear = true})
vim.api.nvim_create_autocmd('User', {
  group = 'ArctgxLualine',
  pattern = 'IdeStatusChanged',
  callback = function ()
    vim.api.nvim_cmd({cmd = 'redrawtabline'}, {})
  end,
})
