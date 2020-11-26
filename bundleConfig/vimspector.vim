nmap <Plug>(ide-debugger-run) <Plug>VimspectorContinue
nmap <Plug>(ide-debugger-close) <Plug>VimspectorStop
 " <Plug>VimspectorRestart
 " <Plug>VimspectorPause
nmap <Plug>(ide-debugger-toggle-breakpoint) <Plug>VimspectorToggleBreakpoint
 " <Plug>VimspectorToggleConditionalBreakpoint
 " <Plug>VimspectorAddFunctionBreakpoint
nmap <Plug>(ide-debugger-step-over) <Plug>VimspectorStepOver
nmap <Plug>(ide-debugger-step-into) <Plug>VimspectorStepInto
nmap <Plug>(ide-debugger-step-out) <Plug>VimspectorStepOut
nmap <Plug>(ide-debugger-run-to-cursor) <Plug>VimspectorRunToCursor

let g:vimspector_sign_priority = {
      \    'vimspectorBP':         99,
      \    'vimspectorBPCond':     99,
      \    'vimspectorBPDisabled': 9,
      \ }
