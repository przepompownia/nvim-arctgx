scriptencoding utf-8

function s:loadHighlight() abort
  highlight DbgBreakptLine ctermbg=113 ctermfg=244 guibg=#008800 guifg=#dddddd
  highlight DbgBreakptSign ctermbg=113 ctermfg=244 guibg=#008800 guifg=#dddddd
  highlight DbgCurrentLine ctermbg=124 ctermfg=244 guibg=#880000 guifg=#dddddd
  highlight DbgCurrentSign ctermbg=124 ctermfg=244 guibg=#880000 guifg=#dddddd
  highlight DbgDisabledLine ctermbg=114 ctermfg=244 guibg=#b4ee9a guifg=#888888
  highlight DbgDisabledSign ctermbg=114 ctermfg=244 guibg=#b4ee9a guifg=#888888
endfunction

augroup vdebugConfig
  autocmd!
  autocmd BufFilePost DebuggerWatch setlocal foldmethod=manual
  autocmd ColorScheme * call s:loadHighlight()
augroup END

let g:vdebug_options = get(g:, 'vdebug_options', {})
let g:vdebug_options['break_on_open'] = 0
let g:vdebug_options['marker_default'] = '⬦'
let g:vdebug_options['marker_open_tree'] = '▽'
let g:vdebug_options['sign_disabled'] = '○'
let g:vdebug_options['sign_breakpoint'] = '●'
let g:vdebug_options['marker_closed_tree'] = '▷'
let g:vdebug_options['watch_window_style'] = 'compact'
let g:vdebug_options['watch_window_height'] = 45
let g:vdebug_options['status_window_height'] = 5
let g:vdebug_features = { 'max_children': 128 }
let g:vdebug_keymap = get(g:, 'vdebug_keymap', {})
let g:vdebug_keymap['run'] = '<Plug>(ide-debugger-run)'
let g:vdebug_keymap['close'] = '<Plug>(ide-debugger-close)'
let g:vdebug_keymap['detach'] = '<Plug>(ide-debugger-detach)'
let g:vdebug_keymap['step_over'] = '<Plug>(ide-debugger-step-over)'
let g:vdebug_keymap['step_into'] = '<Plug>(ide-debugger-step-into)'
let g:vdebug_keymap['step_out'] = '<Plug>(ide-debugger-step-out)'
let g:vdebug_keymap['run_to_cursor'] = '<Plug>(ide-debugger-run-to-cursor)'
let g:vdebug_keymap['set_breakpoint'] = '<Plug>(ide-debugger-toggle-breakpoint)'
let g:vdebug_keymap['get_context'] = '<Plug>(ide-debugger-get-context)'
let g:vdebug_keymap['eval_under_cursor'] = '<Plug>(ide-debugger-eval-under-cursor)'
let g:vdebug_keymap['eval_visual'] = '<Plug>(ide-debugger-debugger-eval-visual)'
" let g:vdebug_options['debug_file_level'] = 1
