local widgets = require "arctgx.widgets"
local arctgxString = require('arctgx.string')
local telescope = require('arctgx.telescope')
local nord = require('lualine.themes.nord')

local function formatFilename(name)
  name = name:gsub('[.][^.]+$', '')

  return arctgxString.shorten(name, 8)
end

local debugWidgetLength = 4

require('lualine').setup({
  extensions = {
    'nvim-tree',
    'quickfix',
  },
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
            if vim.opt.bg:get() == 'light' then
              return {
                fg = '#888888',
                bg = '#bebebe',
                gui = 'bold',
              }
            end
            return nord.inactive.c
          end,
          active = function ()
            if vim.opt.bg:get() == 'light' then
              return {
                fg = '#a7a7a7',
                bg = '#ffffff',
                gui = 'bold',
              }
            end
            return nord.normal.c
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

local augroup = vim.api.nvim_create_augroup('ArctgxLualine', {clear = true})
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'IdeStatusChanged',
  callback = function ()
    vim.api.nvim_cmd({cmd = 'redrawtabline'}, {})
  end,
})
