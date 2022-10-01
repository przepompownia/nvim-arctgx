local extension = {}

--- from https://github.com/neovim/neovim/blob/95fd1ad83e24bbb14cc084fb001251939de6c0a9/runtime/lua/vim/treesitter.lua#L257
function extension.getCapturesBeforeCursor(winnr)
  winnr = winnr or 0
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local cursor = vim.api.nvim_win_get_cursor(winnr)

  local data = vim.treesitter.get_captures_at_pos(bufnr, cursor[1] - 1, math.max(0, cursor[2] - 1))

  local captures = {}

  for _, capture in ipairs(data) do
    table.insert(captures, capture.capture)
  end

  return captures
end

return extension
