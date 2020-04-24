scriptencoding utf-8
augroup vdebugConfig
  autocmd!
  autocmd BufFilePost DebuggerWatch setlocal foldmethod=manual
augroup END

let g:vdebug_options = get(g:, 'vdebug_options', {})
let g:vdebug_options['break_on_open']=0
let g:vdebug_options['marker_default']='○'
let g:vdebug_options['marker_open_tree']='▽'
let g:vdebug_options['marker_closed_tree']='▷'
let g:vdebug_options['watch_window_style']='compact'
let g:vdebug_options['watch_window_height']=45
let g:vdebug_options['status_window_height']=5
let g:vdebug_features = { 'max_children': 128 }
let g:vdebug_keymap = get(g:, 'vdebug_keymap', {})
let g:vdebug_keymap['step_over'] = '<F8>'
let g:vdebug_keymap['step_into'] = '<F7>'
let g:vdebug_keymap['step_out'] = '<S-F7>'
let g:vdebug_keymap['detach'] = '<S-F6>'
