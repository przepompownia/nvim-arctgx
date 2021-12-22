require('dapui').setup({})
vim.cmd([[
    nnoremap <silent> <Plug>(ide-debugger-ui-toggle) :lua require'dapui'.toggle()<CR>
    xmap <Plug>(ide-debugger-eval-popup) <Cmd>lua require("dapui").eval()<CR>
    highlight link DapUIVariable Normal
    highlight DapUIScope guifg=#455284
    highlight DapUIType guifg=#456519
    highlight link DapUIValue Normal
    highlight DapUIModifiedValue guifg=#455284 gui=bold
    highlight DapUIDecoration guifg=#455284
    highlight DapUIThread guifg=#A9FF68
    highlight DapUIStoppedThread guifg=#455284
    highlight link DapUIFrameName Normal
    highlight DapUISource guifg=#3E6B00
    highlight DapUILineNumber guifg=#455284
    highlight DapUIFloatBorder guifg=#455284
    highlight DapUIWatchesEmpty guifg=#666666
    highlight DapUIWatchesValue guifg=#A9FF68
    highlight DapUIWatchesError guifg=#8E2E28
    highlight DapUIBreakpointsPath guifg=#455284
    highlight DapUIBreakpointsInfo guifg=#A9FF68
    highlight DapUIBreakpointsCurrentLine guifg=#A9FF68 gui=bold
    highlight link DapUIBreakpointsLine DapUILineNumber
]])
