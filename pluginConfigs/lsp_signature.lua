require "lsp_signature".setup()
local api = vim.api

api.nvim_create_user_command(
  'LSPSignatureClearNamespace',
  function(opts)
    api.nvim_buf_clear_namespace(0, api.nvim_get_namespaces()['lsp_signature_vt'], 0, -1)
  end,
  {
    nargs = 0,
  }
)
