vim.lsp.set_log_level(vim.log.levels.WARN)

local border = 'rounded'
local origUtilOpenFloatingPreview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return origUtilOpenFloatingPreview(contents, syntax, opts, ...)
end
