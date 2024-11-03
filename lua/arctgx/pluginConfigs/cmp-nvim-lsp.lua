local lsp = require('arctgx.lsp')
lsp.extendClientCapabilities(require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()))
