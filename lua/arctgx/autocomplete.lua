local api = vim.api
local augroup = api.nvim_create_augroup('arctgx.autocomplete', {clear = true})

local autocomplete = {}

function autocomplete.enable()
  vim.o.autocomplete = true
  api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    pattern = 'buftype',
    callback = function ()
      local buf = api.nvim_get_current_buf()
      if vim.v.option_new == 'prompt' or vim.bo[buf].filetype == 'namu_prompt' then
        vim.bo[buf].autocomplete = false
        return
      end
    end
  })
end

return autocomplete
