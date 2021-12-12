require('dapui').setup({})
vim.cmd([[
    nnoremap <silent> <Plug>(ide-debugger-ui-toggle) :lua require'dapui'.toggle()<CR>
]])
