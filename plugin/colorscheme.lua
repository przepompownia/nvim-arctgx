local api = vim.api
local augroup = api.nvim_create_augroup('ColorschemeLoading', {clear = true})
api.nvim_create_autocmd('OptionSet', {
  group = augroup,
  pattern = 'background',
  nested = true,
  callback = function ()
    local function theme()
      if vim.v.option_new == 'light' then
        return vim.g.colorschemeLight or 'delek'
      end

      return vim.g.colorschemeDark or 'darkblue'
    end
    api.nvim_cmd({cmd = 'colorscheme', args = {theme()}}, {})
  end
})
