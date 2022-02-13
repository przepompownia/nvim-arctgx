local dap = require 'dap'
local keymap = require 'vim.keymap'
local php = require('arctgx.dap.php')
local widgets = require('dap.ui.widgets')
local vim = vim

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/home/arctgx/.vim/pack/bundle/opt/arctgx/bundleConfig/vimspector-config/gadgets/linux/vscode-php-debug/out/phpDebug.js' }
}

local sidebar = widgets.sidebar(widgets.scopes)
local function toggle_scopes()
  local scopes = widgets.sidebar(widgets.scopes)
  scopes.toggle()
end

local function toggle_frames()
  local frames = widgets.sidebar(widgets.frames)
  frames.toggle()
end

vim.api.nvim_add_user_command('DAPWidgetScopes', toggle_scopes, {})
vim.api.nvim_add_user_command('DAPWidgetFrames', toggle_frames, {})

vim.fn.sign_define('DapBreakpoint', {text='●', texthl='IdeBreakpointSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapBreakpointCondition', {text='◆', texthl='IdeBreakpointSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapBreakpointRejected', {text='R', texthl='IdeCodeWindowCurrentFrameSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapLogPoint', {text='L', texthl='IdeCodeWindowCurrentFrameSign', linehl='', numhl='IdeBreakpointLineNr'})
vim.fn.sign_define('DapStopped', {text='▶', texthl='IdeCodeWindowCurrentFrameSign', linehl='CursorLine', numhl=''})

local opts = {silent = true, noremap = true}
keymap.set({'n'}, '<Plug>(ide-debugger-run)', dap.continue, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-step-over)', dap.step_over, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-step-into)', dap.step_into, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-step-out)', dap.step_out, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-toggle-breakpoint)', dap.toggle_breakpoint, opts)
keymap.set(
  {'n'},
  '<Plug>(ide-debugger-toggle-breakpoint-conditional)',
  function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  opts
)
keymap.set({'n'}, '<Plug>(ide-debugger-up-frame)', dap.up, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-down-frame)', dap.down, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-run-to-cursor)', dap.run_to_cursor, opts)
keymap.set({'n'}, '<Plug>(ide-debugger-close)', dap.close, opts)
-- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
dap.configurations.php = { php.default }
