scriptencoding utf-8
augroup vdebugConfig
  autocmd!
  autocmd BufFilePost DebuggerWatch setlocal foldmethod=manual
augroup END

highlight DbgBreakptLine ctermbg=113 ctermfg=244 guibg=#008800 guifg=#dddddd
highlight DbgBreakptSign ctermbg=113 ctermfg=244 guibg=#008800 guifg=#dddddd
highlight DbgCurrentLine ctermbg=124 ctermfg=244 guibg=#880000 guifg=#dddddd
highlight DbgCurrentSign ctermbg=124 ctermfg=244 guibg=#880000 guifg=#dddddd
highlight DbgDisabledLine ctermbg=114 ctermfg=244 guibg=#b4ee9a guifg=#888888
highlight DbgDisabledSign ctermbg=114 ctermfg=244 guibg=#b4ee9a guifg=#888888

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
let g:vdebug_keymap['step_over'] = '<F8>'
let g:vdebug_keymap['step_into'] = '<F7>'
let g:vdebug_keymap['step_out'] = '<S-F7>'
let g:vdebug_keymap['detach'] = '<S-F6>'
" let g:vdebug_options['debug_file_level'] = 1
