local nord = require('lualine.themes.nord')

require('lualine').setup({
  extensions = {
    'nvim-tree',
    'quickfix',
  },
  options = {
    theme = 'nord',
    component_separators = {left = '', right = ''},
    disabled_filetypes = {
      'fern',
      'dap-repl',
      'dapui_watches',
      'dapui_scopes',
      'dapui_breakpoints',
      'dapui_stacks',
    },
  },
  sections = {
    lualine_b = {
      {
        'branch',
        on_click = function (_numberOfClicks, button, _modifiers)
          if 'r' == button then
            require('arctgx.telescope').branches()
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
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {
      'location',
      {
        function ()
          local out = ''
          for _, hook in ipairs(require('arctgx.widgets').getDebugHooks()) do
            local data = hook()
            local symbol = data.session and '⛧ ' or '☠'
            out = out .. symbol .. ' ' .. data.status
          end
          return out
        end,
        color = nord.normal.c,
        separator = {
          left = '',
        },
      },
    },
  },
})

local augroup = vim.api.nvim_create_augroup('ArctgxLualine', {clear = true})
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'IdeStatusChanged',
  callback = function ()
    vim.api.nvim_cmd({cmd = 'redrawtabline'}, {})
  end,
})
