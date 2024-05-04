require 'treesitter-context'.setup {
  enable = true,
  on_attach = function (buf)
    local excludedFiletypes = {
      'noice',
    }

    if vim.tbl_contains(excludedFiletypes, vim.bo[buf].filetype) then
      return false
    end

    return true
  end,
  max_lines = 0,
  min_window_height = 15,
  line_numbers = true,
  multiline_threshold = 1,
  trim_scope = 'outer',
  mode = 'cursor',
  separator = '-',
  zindex = 20,
}
