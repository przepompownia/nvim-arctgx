vim.g.colorschemeDark = 'nord'
require('nord').setup {
  diff = {mode = 'fg'},
  on_highlights = function (highlights, _colors)
    highlights['@error'] = {fg = '#880000'}
  end,
}
