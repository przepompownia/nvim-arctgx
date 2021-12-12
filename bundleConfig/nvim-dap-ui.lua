require('dapui').setup({})
vim.cmd([[
    nnoremap <silent> <Plug>(ide-debugger-ui-toggle) :lua require'dapui'.toggle()<CR>
    xmap <Plug>(ide-debugger-eval-popup) <Cmd>lua require("dapui").eval()<CR>
]])
