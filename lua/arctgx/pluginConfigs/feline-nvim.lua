local feline = require('feline')
local viMode = require('feline.providers.vi_mode')
local modeHl = viMode.get_mode_highlight_name
local modeColor = viMode.get_mode_color
local widgets = require('arctgx.widgets')
local bo = vim.bo
local b = vim.b
local api = vim.api
local ns = require('arctgx.lsp').ns()

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

for _, name in ipairs({'Error', 'Hint', 'Warn', 'Info'}) do
  api.nvim_set_hl(ns, 'StlDiagnostic' .. name, vim.tbl_extend(
    'force',
    vim.api.nvim_get_hl(0, {name = 'Diagnostic' .. name}),
    {bg = colors.nord1}
  ))
end

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
  local name = 'FelineModeSep' .. string.byte(char)
  return {str = char, hl = function () return {name = name .. modeHl(), fg = modeColor(), bg = colors.nord1} end}
end

feline.setup({
  colors = {bg = colors.bg, fg = colors.fg},
  vi_mode_colors = viModeColors,
  disable = {
    buftypes = {
      '^nofile$',
      '^prompt$',
    },
  },
  components = {
    inactive = {
      {
        {
          provider = 'file_info',
          icon = '',
          hl = {name = 'FelineFileInfo', bg = colors.bg, fg = colors.nord5},
          left_sep = {str = ' ', hl = {name = 'FelineFileInfoLeftSep', bg = colors.bg}},
        },
        {
          provider = 'search_count',
          icon = ' ',
          hl = {name = 'FelineSearchCount', bg = colors.bg, fg = colors.nord5},
        },
      },
      {},
      {
        {
          provider = 'position',
          hl = {name = 'FelinePosition', bg = colors.bg, fg = colors.nord5},
        },
      },
    },
    active = {
      {
        {
          provider = function () return ' ' .. viMode.get_vim_mode() .. ' ' end,
          hl = function () return {name = 'FelineModeHl' .. modeHl(), bg = modeColor(), fg = colors.nord1} end,
          right_sep = modeSep(''),
        },
        {
          provider = function ()
            return '  ' .. (b.gitsigns_head or '[none]')
          end,
          hl = {name = 'FelineBranch', fg = colors.nord5, bg = colors.nord1},
        },
        {
          provider = function ()
            return widgets.renderVcsSummary('Normal')
          end,
          enabled = function ()
            return b.gitsigns_status ~= ''
          end,
          hl = {name = 'FelineVcs', fg = colors.nord5},
          left_sep = {str = '  ', hl = {name = 'FelineVcsLeftSep', fg = colors.nord5, bg = colors.nord1}},
        },
        {
          provider = function ()
            return widgets.renderDiagnosticsSummary('Normal')
          end,
          enabled = function ()
            return vim.tbl_count(vim.diagnostic.count(0, {})) > 0
          end,
          hl = {name = 'FelineDiags', fg = colors.nord5, bg = colors.nord1},
          left_sep = {str = '  ', hl = {name = 'FelineDiagsLeftSep', fg = colors.nord5, bg = colors.nord1}},
        },
        {
          provider = 'file_info',
          icon = '',
          hl = {name = 'FelineFileInfo', bg = colors.bg, fg = colors.nord5},
          left_sep = {str = '█ ', hl = {name = 'FelineFileInfoLeftSep', bg = colors.nord3, fg = colors.nord1}},
        },
        {
          provider = 'search_count',
          icon = ' ',
          hl = {name = 'FelineSearchCount', bg = colors.bg, fg = colors.nord5},
        },
        {
          provider = 'macro',
          icon = ' ',
          hl = {name = 'FelineRecording', bg = colors.bg, fg = colors.nord13},
        },
      },
      {
        {
          provider = function ()
            return widgets.renderDebug({
              active = 'DebugWidgetActive',
              inactive = 'DebugWidgetInactive',
              fallback = 'FelineFileInfo',
            })
          end,
          hl = {name = 'FelineDebugWidget', bg = colors.bg, fg = colors.nord5},
        },
        {
          provider = function () return ((bo.fenc ~= '' and bo.fenc) or vim.o.enc) end,
          hl = {name = 'FelineFenc', bg = colors.bg, fg = colors.nord5},
          left_sep = {str = ' ', hl = {name = 'FelineFencLeftSep', bg = colors.bg}},
        },
        {
          provider = function () return (bo.fileformat ~= '' and bo.fileformat) or vim.o.fileformat end,
          hl = {name = 'FelineFileformat', bg = colors.bg, fg = colors.nord5},
          left_sep = {str = ' ', hl = {name = 'FelineFileformatLeftSep', bg = colors.bg}},
        },
        {
          provider = function () return bo.filetype end,
          hl = {name = 'FelineFileType', bg = colors.bg, fg = colors.nord5},
          left_sep = {str = ' ', hl = {name = 'FelineFileTypeLeftSep', bg = colors.bg}},
        },
        {
          provider = 'line_percentage',
          hl = {name = 'FelineLinePercentage', bg = colors.nord1, fg = colors.nord5},
          left_sep = {str = ' █', hl = {name = 'FelineLinePercentageLeftSep', fg = colors.nord1}},
          right_sep = {str = ' ', hl = {name = 'FelineLinePercentageRightSep', bg = colors.nord1}},
        },
        {
          provider = {
            name = 'position',
            opts = {
              format = ' {line}:{col} ',
              padding = {line = 3, col = 2},
            },
          },
          hl = function () return {name = 'FelinePosItion' .. modeHl(), bg = modeColor(), fg = colors.nord1} end,
          left_sep = modeSep(''),
        },
      },
    },
  },
})

feline.use_theme(colors)
