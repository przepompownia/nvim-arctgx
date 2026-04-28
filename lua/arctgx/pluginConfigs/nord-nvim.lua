vim.g.colorschemeDark = 'nord'
require('nord').setup {
  diff = {mode = 'fg'},
  on_highlights = function (highlights, colors)
    highlights['@error'] = {fg = '#880000'}
    highlights['DiffviewCommitLocalOnly'] = {fg = colors.aurora.yellow}
  end,
}
