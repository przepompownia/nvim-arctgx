local api = vim.api

local extension = {}

---@param filetypes table
---@param callback fun(winId: integer): any
function extension.forEachWindowWithBufFileType(filetypes, callback)
  vim.validate({filetypes = {filetypes, {'table'}}})
  vim.iter(api.nvim_list_wins())
    :filter(function (winId)
      return api.nvim_win_is_valid(winId)
        and vim.tbl_contains(filetypes, vim.bo[api.nvim_win_get_buf(winId)].filetype)
    end)
    :each(callback)
end

return extension
