local arctgxLsp = require 'arctgx.lsp'

require('nlua.lsp.nvim').setup(require('lspconfig'), {
  on_attach = arctgxLsp.onAttach,
})
