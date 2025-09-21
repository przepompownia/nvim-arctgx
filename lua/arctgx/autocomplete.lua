local api = vim.api
local augroup = api.nvim_create_augroup('arctgx.autocomplete', {clear = true})

local autocomplete = {}

function autocomplete.enable()
  vim.o.autocomplete = true
  api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    pattern = 'buftype',
    callback = function ()
      if vim.v.option_new ~= 'prompt' then
        return
      end
      vim.bo[api.nvim_get_current_buf()].autocomplete = false
    end
  })
end

return autocomplete
