local lsp = require('arctgx.lsp')
lsp.extendClientCapabilities(require('cmp_nvim_lsp').default_capabilities(lsp.defaultClientCapabilities()))
