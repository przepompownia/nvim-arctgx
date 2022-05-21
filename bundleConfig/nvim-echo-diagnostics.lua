require("echo-diagnostics").setup{
    show_diagnostic_number = true,
}
vim.api.nvim_create_augroup('ArctgxEchoDiagnostics', {clear = true})
vim.api.nvim_create_autocmd('CursorHold', {
  group = 'ArctgxEchoDiagnostics',
  callback = require('echo-diagnostics').echo_line_diagnostic,
})
