local api = vim.api
vim.g.modus_dim_inactive_window = 0
api.nvim_create_augroup('ColorschemeLoading', {clear = true})
api.nvim_create_autocmd('OptionSet', {
  group = 'ColorschemeLoading',
  pattern = 'background',
  nested = true,
  callback = function ()
    local function theme()
      if vim.v.option_new == 'light' then
        return 'modus-operandi'
      end

      return 'modus-vivendi'
    end
    api.nvim_cmd({cmd = 'colorscheme', args = {theme()}}, {})
  end
})
