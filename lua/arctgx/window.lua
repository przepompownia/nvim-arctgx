local extension = {}

--- @param filetypes table
--- @param callback fun(winId: integer): any
function extension.forEachWindowWithBufFileType(filetypes, callback)
  vim.validate({filetypes = {filetypes, {'table'}}})
  for _, winId in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(winId)
      and vim.tbl_contains(filetypes, vim.bo[vim.api.nvim_win_get_buf(winId)].filetype) then
      callback(winId)
    end
  end
end

return extension
