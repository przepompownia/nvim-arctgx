require 'treesitter-context'.setup({
  enable = true,
  on_attach = function (buf)
    local excludedFiletypes = {
      'noice',
      'dapui_stacks',
      'dapui_watches',
      'dapui_scopes',
      'dapui_breakpoints',
      'NvimTree',
      'dap-view',
      'cmd',
      'dialog',
      'msg',
      'pager',
    }

    return not vim.tbl_contains(excludedFiletypes, vim.bo[buf].filetype)
  end,
  max_lines = 0,
  min_window_height = 15,
  line_numbers = true,
  multiline_threshold = 1,
  trim_scope = 'outer',
  mode = 'cursor',
  separator = '-',
  zindex = 20,
  -- multiwindow = true,
})
