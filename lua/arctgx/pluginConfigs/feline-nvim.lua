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

local viModeColors = {
  ['NORMAL'] = colors.nord8,
  ['OP'] = 'green',
  ['CONFIRM'] = 'orange',
  ['INSERT'] = colors.nord6,
  ['VISUAL'] = colors.nord7,
  ['LINES'] = colors.nord7,
  ['BLOCK'] = colors.nord7,
  ['REPLACE'] = colors.nord13,
  ['V-REPLACE'] = colors.nord13,
  ['ENTER'] = 'cyan',
  ['MORE'] = 'cyan',
  ['SELECT'] = colors.nord7,
  ['COMMAND'] = 'green',
  ['SHELL'] = 'green',
  ['TERM'] = 'green',
  ['NONE'] = colors.nord1,
}

local function modeSep(char)
  return {
    str = char,
    hl = function ()
      return {
        fg = viMode.get_mode_color(),
        bg = colors.bg,
      }
    end,
  }
end

feline.setup({
  colors = {bg = colors.bg, fg = colors.fg},
  vi_mode_colors = viModeColors,
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
          provider = function ()
            return ' ' .. viMode.get_vim_mode() .. ' '
          end,
          hl = function ()
            return {
              bg = viMode.get_mode_color(),
              fg = colors.nord1,
            }
          end,
          right_sep = modeSep(''),
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
          provider = function () return bo.filetype end,
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
          provider = {
            name = 'position',
            opts = {
              format = ' {line}:{col} ',
              padding = {
                line = 3,
                col = 2,
              },
            },
          },
          hl = function ()
            return {
              bg = viMode.get_mode_color(),
              fg = colors.nord1,
            }
          end,
          left_sep = modeSep(''),
        },
      },
    },
  },
})

feline.use_theme(colors)
