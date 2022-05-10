local handlers = require 'arctgx.lsp.handlers'

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
})
-- vim.lsp.set_log_level('trace')

vim.fn.sign_define('DiagnosticSignHint', {text = '💡', texthl = 'IdeHintSign', linehl = '', numhl = 'IdeLineNrHint'})
vim.fn.sign_define('DiagnosticSignInfo', {text = '', texthl = 'IdeInfoSign', linehl = '', numhl = 'IdeLineNrInfo'})
vim.fn.sign_define('DiagnosticSignWarn', {text = '⚠', texthl = 'IdeWarningSign', linehl = '', numhl = 'IdeLineNrWarning'})
vim.fn.sign_define('DiagnosticSignError', {text = '', texthl = 'IdeErrorSign', linehl = '', numhl = 'IdeLineNrError'})
