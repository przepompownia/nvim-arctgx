vim.lsp.set_log_level(vim.log.levels.WARN)
local hlMap = {
  LspReferenceRead = 'IdeReferenceRead',
  LspReferenceText = 'IdeReferenceText',
  LspReferenceWrite = 'IdeReferenceWrite'
}
for key, value in pairs(hlMap) do
  vim.api.nvim_set_hl(0, key, {link = value})
end

local border = 'rounded'
local origUtilOpenFloatingPreview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return origUtilOpenFloatingPreview(contents, syntax, opts, ...)
end
