require 'treesitter-context'.setup {
  enable = true,
  max_lines = 0,
  on_attach = function (buf)
    local excludedFiletypes = {
      'noice',
    }

    if vim.tbl_contains(excludedFiletypes, vim.bo[buf].filetype) then
      return false
    end

    return true
  end,
}
