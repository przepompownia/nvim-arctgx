vim.diagnostic.config({
  virtual_text = false,
  underline = false,
})

vim.fn.sign_define('DiagnosticSignHint', {text = '💡', texthl = 'IdeHintSign', linehl = '', numhl = 'IdeLineNrHint'})
vim.fn.sign_define('DiagnosticSignInfo', {text = '', texthl = 'IdeInfoSign', linehl = '', numhl = 'IdeLineNrInfo'})
vim.fn.sign_define('DiagnosticSignWarn', {text = '⚠', texthl = 'IdeWarningSign', linehl = '', numhl = 'IdeLineNrWarning'})
vim.fn.sign_define('DiagnosticSignError', {text = '', texthl = 'IdeErrorSign', linehl = '', numhl = 'IdeLineNrError'})

local ns = vim.api.nvim_create_namespace('arctgx.diagnostic.signs')
local origSignsHandler = vim.diagnostic.handlers.signs

-- from :help diagnostic-handlers-example
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diagnostics = vim.diagnostic.get(bufnr)

    local maxSeverityPerLine = {}
    for _, d in pairs(diagnostics) do
      local m = maxSeverityPerLine[d.lnum]
      if not m or d.severity < m.severity then
        maxSeverityPerLine[d.lnum] = d
      end
    end

    local filteredDiagnostics = vim.tbl_values(maxSeverityPerLine)
    origSignsHandler.show(ns, bufnr, filteredDiagnostics, opts)
  end,
  hide = function(_, bufnr)
    origSignsHandler.hide(ns, bufnr)
  end,
}
