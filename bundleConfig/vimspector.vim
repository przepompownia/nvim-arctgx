nmap <Plug>(ide-debugger-run) <Plug>VimspectorContinue
nmap <Plug>(ide-debugger-close) <Plug>VimspectorStop
 " <Plug>VimspectorRestart
 " <Plug>VimspectorPause
nmap <Plug>(ide-debugger-toggle-breakpoint) <Plug>VimspectorToggleBreakpoint
nmap <Plug>(ide-debugger-toggle-breakpoint-conditional) <Plug>VimspectorToggleConditionalBreakpoint
 " <Plug>VimspectorAddFunctionBreakpoint
nmap <Plug>(ide-debugger-step-over) :<C-U>call vimspector#StepOver()<CR>
nmap <Plug>(ide-debugger-step-into) <Plug>VimspectorStepInto
nmap <Plug>(ide-debugger-step-out) <Plug>VimspectorStepOut
nmap <Plug>(ide-debugger-run-to-cursor) <Plug>VimspectorRunToCursor

let g:vimspector_sign_priority = {
      \    'vimspectorBP':         999,
      \    'vimspectorBPCond':     999,
      \    'vimspectorBPDisabled': 999,
      \ }

augroup VimspectorSettings
  autocmd!

  autocmd User VimspectorUICreated windo doautocmd User IDEDebuggerMapsNeeded
  autocmd User VimspectorJumpedToFrame doautocmd User IDEDebuggerMapsNeeded
augroup END
