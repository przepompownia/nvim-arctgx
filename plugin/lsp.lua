vim.lsp.set_log_level(vim.log.levels.WARN)
local hlMap = {
  LspReferenceRead = 'IdeReferenceRead',
  LspReferenceText = 'IdeReferenceText',
  LspReferenceWrite = 'IdeReferenceWrite'
}
for key, value in pairs(hlMap) do
  vim.api.nvim_set_hl(require('arctgx.lsp').ns(), key, {link = value})
end
vim.api.nvim_set_hl_ns(require('arctgx.lsp').ns())

local border = 'rounded'
local origUtilOpenFloatingPreview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return origUtilOpenFloatingPreview(contents, syntax, opts, ...)
end

vim.keymap.set('n', '<Plug>(ide-diagnostic-info)', function () vim.diagnostic.open_float({border = 'rounded'}) end, {})
vim.keymap.set('n', '<Plug>(ide-diagnostic-goto-previous)', vim.diagnostic.goto_prev, {})
vim.keymap.set('n', '<Plug>(ide-diagnostic-goto-next)', vim.diagnostic.goto_next, {})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {})
