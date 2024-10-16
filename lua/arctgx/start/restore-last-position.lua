local api = vim.api

api.nvim_create_autocmd('BufReadPost', {
  callback = function ()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lines = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
