local dap = require 'dap'

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/home/arctgx/.vim/pack/bundle/opt/arctgx/bundleConfig/vimspector-config/gadgets/linux/vscode-php-debug/out/phpDebug.js' }
}

vim.fn.sign_define('DapBreakpoint', {text='●', texthl='IdeBreakpointSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapBreakpointCondition', {text='◆', texthl='IdeBreakpointSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapBreakpointRejected', {text='R', texthl='IdeCodeWindowCurrentFrameSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapLogPoint', {text='L', texthl='IdeCodeWindowCurrentFrameSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapStopped', {text='▶', texthl='IdeCodeWindowCurrentFrameSign', linehl='CursorLine', numhl=''})

vim.cmd([[
    nnoremap <silent> <Plug>(ide-debugger-run) :lua require'dap'.continue()<CR>
    nnoremap <silent> <Plug>(ide-debugger-step-over) :lua require'dap'.step_over()<CR>
    nnoremap <silent> <Plug>(ide-debugger-step-into) :lua require'dap'.step_into()<CR>
    nnoremap <silent> <Plug>(ide-debugger-step-out) :lua require'dap'.step_out()<CR>
    nnoremap <silent> <Plug>(ide-debugger-toggle-breakpoint) :lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <silent> <Plug>(ide-debugger-toggle-breakpoint-conditional) :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    nnoremap <silent> <Plug>(ide-debugger-up-frame) :lua require'dap'.up()<CR>
    nnoremap <silent> <Plug>(ide-debugger-down-frame) :lua require'dap'.down()<CR>
    nnoremap <silent> <Plug>(ide-debugger-run-to-cursor) :lua require'dap'.run_to_cursor()<CR>
]])
-- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
