local feline = require('feline')
local viMode = require('feline.providers.vi_mode')
local bo = vim.bo

local colors = {
  bg        = '#4C566A',
  fg        = '#3B4252',
  black     = '#3B4252',
  skyblue   = '#50B0F0',
  cyan      = '#009090',
  green     = '#60A040',
  oceanblue = '#0066cc',
  magenta   = '#C26BDB',
  orange    = '#FF9000',
  red       = '#D10000',
  violet    = '#9E93E8',
  white     = '#FFFFFF',
  yellow    = '#E1E120',
  nord1     = '#3B4252',
  nord3     = '#4C566A',
  nord5     = '#E5E9F0',
  nord6     = '#ECEFF4',
  nord7     = '#8FBCBB',
  nord8     = '#88C0D0',
  nord13    = '#EBCB8B',
}

feline.setup({
  components = {
    inactive = {
      {
        {
          provider = 'file_info',
          icon = '',
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = ' ',
          right_sep = ' ',
        },
      },
      {},
      {
        {
          provider = 'position',
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = '',
          right_sep = ' ',
        },
      },
    },
    active = {
      {
        {
          provider = '▊ ',
          hl = {
            fg = colors.nord3,
          },
        },
        {
          provider = function ()
            return viMode.get_vim_mode()
          end,
          hl = function ()
            return {
              name = viMode.get_mode_highlight_name(),
              fg = viMode.get_mode_color(),
            }
          end,
          left_sep = ' ',
        },
        {
          provider = 'git_branch',
          hl = {
            fg = colors.nord5,
            bg = colors.nord3,
          },
          left_sep = {
            str = ' ',
            hl = {
              bg = colors.nord3,
            },
          },
          right_sep = {
            str = ' ',
            hl = {
              fg = 'NONE',
              bg = colors.nord3,
            },
          },
        },
        {
          provider = 'git_diff_added',
          hl = {
            fg = 'green',
            bg = colors.nord3,
          },
        },
        {
          provider = 'git_diff_changed',
          hl = {
            fg = 'orange',
            bg = colors.nord3,
          },
        },
        {
          provider = 'git_diff_removed',
          hl = {
            fg = 'red',
            bg = colors.nord3,
          },
          right_sep = {
            str = ' ',
            hl = {
              fg = 'NONE',
              bg = colors.nord3,
            },
          },
        },
        {
          provider = 'diagnostic_errors',
          hl = {fg = 'red'},
        },
        {
          provider = 'diagnostic_warnings',
          hl = {fg = 'yellow'},
        },
        {
          provider = 'diagnostic_hints',
          hl = {fg = 'cyan'},
        },
        {
          provider = 'diagnostic_info',
          hl = {fg = 'skyblue'},
        },
        {
          provider = 'file_info',
          icon = '',
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = ' ',
          right_sep = ' ',
        },
      },
      {
      },
      {
        {
          provider = function () return ((bo.fenc ~= '' and bo.fenc) or vim.o.enc) end,
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              bg = colors.bg,
            },
          },
          right_sep = {
            {
              str = ' ',
              hl = {
                bg = colors.bg,
              },
            },
            ' ',
          },
        },
        {
          provider = function () return (bo.fileformat ~= '' and bo.fileformat) or vim.o.fileformat end,
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              bg = colors.bg,
            },
          },
          right_sep = {
            {
              str = ' ',
              hl = {
                bg = colors.bg,
              },
            },
            ' ',
          },
        },
        {
          provider =function () return bo.filetype end,
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              bg = colors.bg,
            },
          },
          right_sep = {
            {
              str = ' ',
              hl = {
                bg = colors.bg,
              },
            },
            ' ',
          },
        },
        {
          provider = 'line_percentage',
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = '  ',
          right_sep = ' ',
        },
        {
          provider = 'position',
          hl = {
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = '',
          right_sep = ' ',
        },
      },
    },
  },
})

feline.use_theme(colors)
