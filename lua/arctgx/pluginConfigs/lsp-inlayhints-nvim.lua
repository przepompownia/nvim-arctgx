local augroup = vim.api.nvim_create_augroup('LspAttachInlayhints', {clear = true})
require "lsp-inlayhints.config".load({
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require('lsp-inlayhints').on_attach(client, bufnr)
  end,
})
