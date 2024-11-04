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
        name = 'FelineModeSep' .. string.byte(char) .. require('feline.providers.vi_mode').get_mode_highlight_name(),
        fg = viMode.get_mode_color(),
        bg = colors.nord1,
      }
    end,
  }
end

-- todo search index number

local function gitDiff(type)
  ---@diagnostic disable-next-line: undefined-field
  local gsd = vim.b.gitsigns_status_dict

  if gsd and gsd[type] and gsd[type] > 0 then
    return tostring(gsd[type])
  end

  return ''
end

feline.setup({
  colors = {bg = colors.bg, fg = colors.fg},
  vi_mode_colors = viModeColors,
  disable = {
    buftypes = {
      '^nofile$'
    },
  },
  components = {
    inactive = {
      {
        {
          provider = 'file_info',
          icon = '',
          hl = {
            name = 'FelineFileInfo',
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineFileInfoLeftSep',
              bg = colors.bg,
            },
          },
        },
      },
      {},
      {
        {
          provider = 'position',
          hl = {
            name = 'FelinePosition',
            bg = colors.bg,
            fg = colors.nord5,
          },
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
              name = 'FelineModeHl' .. require('feline.providers.vi_mode').get_mode_highlight_name(),
              bg = viMode.get_mode_color(),
              fg = colors.nord1,
            }
          end,
          right_sep = modeSep(''),
        },
        {
          provider = function ()
            return '  ' .. (vim.b.gitsigns_head or '[none]') .. ' '
          end,
          hl = {
            name = 'FelineBranch',
            fg = colors.nord5,
            bg = colors.nord1,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineBranchLeftSep',
              bg = colors.nord1,
            },
          },
          right_sep = {
            str = ' ',
            hl = {
              name = 'FelineBranchRightSep',
              fg = 'NONE',
              bg = colors.nord1,
            },
          },
        },
        {
          provider = function ()
            return ' +' .. gitDiff('added')
          end,
          hl = {
            name = 'FelineDiffAdded',
            fg = 'green',
            bg = colors.nord1,
          },
        },
        {
          provider = function ()
            return ' ~' .. gitDiff('changed')
          end,
          hl = {
            name = 'FelineDiffChanged',
            fg = 'orange',
            bg = colors.nord1,
          },
        },
        {
          provider = function ()
            return ' -' .. gitDiff('removed')
          end,
          hl = {
            name = 'FelineDiffRemoved',
            fg = 'red',
            bg = colors.nord1,
          },
          right_sep = {
            str = ' ',
            hl = {
              name = 'FelineDiffRemovedRightSep',
              fg = colors.nord5,
              bg = colors.nord1,
            },
          },
        },
        {
          provider = 'diagnostic_errors',
          hl = {
            name = 'FelineDiagErrors',
            fg = 'red',
            bg = colors.nord1,
          },
        },
        {
          provider = 'diagnostic_warnings',
          hl = {
            name = 'FelineDiagWarnings',
            fg = 'yellow',
            bg = colors.nord1,
          },
        },
        {
          provider = 'diagnostic_hints',
          hl = {
            name = 'FelineDiagHints',
            fg = 'cyan',
            bg = colors.nord1,
          },
        },
        {
          provider = 'diagnostic_info',
          hl = {
            name = 'FelineDiagInfo',
            fg = 'skyblue',
            bg = colors.nord1,
          },
        },
        {
          provider = 'file_info',
          icon = '',
          hl = {
            name = 'FelineFileInfo',
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineFileInfoLeftSep',
              bg = colors.bg,
            },
          },
        },
      },
      {
      },
      {
        {
          provider = function () return ((bo.fenc ~= '' and bo.fenc) or vim.o.enc) end,
          hl = {
            name = 'FelineFenc',
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineFencLeftSep',
              bg = colors.bg,
            },
          },
        },
        {
          provider = function () return (bo.fileformat ~= '' and bo.fileformat) or vim.o.fileformat end,
          hl = {
            name = 'FelineFileformat',
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineFileformatLeftSep',
              bg = colors.bg,
              bg = colors.bg,
            },
          },
        },
        {
          provider = function () return bo.filetype end,
          hl = {
            name = 'FelineFileType',
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineFileTypeLeftSep',
              bg = colors.bg,
            },
          },
        },
        {
          provider = 'line_percentage',
          hl = {
            name = 'FelineLinePercentage',
            bg = colors.bg,
            fg = colors.nord5,
          },
          left_sep = {
            str = ' ',
            hl = {
              name = 'FelineLinePercentageLeftSep',
              bg = colors.bg,
            },
          },
          right_sep = {
            str = ' ',
            hl = {
              name = 'FelineLinePercentageRightSep',
              bg = colors.bg,
            },
          },
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
              name = 'FelinePosItion' .. require('feline.providers.vi_mode').get_mode_highlight_name(),
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
