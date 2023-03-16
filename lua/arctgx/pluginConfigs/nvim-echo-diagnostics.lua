require("echo-diagnostics").setup{
    show_diagnostic_number = true,
}
local augroup = vim.api.nvim_create_augroup('ArctgxEchoDiagnostics', {clear = true})
vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup,
  callback = require('echo-diagnostics').echo_line_diagnostic,
})
