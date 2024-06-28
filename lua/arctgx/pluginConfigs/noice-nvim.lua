require('noice').setup({
  messages = {
    view = 'mini',
    view_search = false,
    view_error = 'mini',
    view_warn = 'mini',
  },
  notify = {
    enabled = true,
    view = 'mini',
  },
  lsp = {
    override = {
      -- ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- ["vim.lsp.util.stylize_markdown"] = true,
      -- ["cmp.entry.get_documentation"] = true,
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        luasnip = true,
        throttle = 50,
      },
      view = nil, -- {
      ---@type NoiceViewOptions
      -- opts = {
      --   win_options = { border = 'rounded' },
      -- },
    },
    hover = {
      enabled = false,
      view = nil,
      ---@type NoiceViewOptions
      opts = {},
    },
  },
  views = {
    cmdline_input = {
      relative = 'editor',
    },
    mini = {
      timeout = 5000,
      reverse = false,
    },
  },
  presets = {
    lsp_doc_border = true,
  },
})

vim.keymap.set('c', '<A-CR>', function ()
  require('noice').redirect(vim.fn.getcmdline())
  vim.api.nvim_input('<esc>')
end, {desc = 'Redirect Cmdline'})
