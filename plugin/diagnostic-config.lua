vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  float = {
    border = 'rounded',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '󰀪',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
})

local ns = vim.api.nvim_create_namespace('arctgx.diagnostic.signs')
local origSignsHandler = vim.diagnostic.handlers.signs

-- from :help diagnostic-handlers-example
vim.diagnostic.handlers.signs = {
  show = function (_, bufnr, _, opts)
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
  hide = function (_, bufnr)
    if vim.api.nvim_buf_is_valid(bufnr) then
      origSignsHandler.hide(ns, bufnr)
    end
  end,
}
