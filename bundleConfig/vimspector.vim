let g:vimspector_base_dir=expand( '<sfile>:p:h' ) . '/vimspector-config'

nmap <Plug>(ide-debugger-run) <Plug>VimspectorContinue
nmap <Plug>(ide-debugger-close) <Plug>VimspectorStop
 " <Plug>VimspectorRestart
 " <Plug>VimspectorPause
nmap <Plug>(ide-debugger-toggle-breakpoint) <Plug>VimspectorToggleBreakpoint
nmap <Plug>(ide-debugger-toggle-breakpoint-conditional) <Plug>VimspectorToggleConditionalBreakpoint
 " <Plug>VimspectorAddFunctionBreakpoint
nmap <Plug>(ide-debugger-step-over) <Cmd>call vimspector#StepOver()<CR>
nmap <Plug>(ide-debugger-step-into) <Plug>VimspectorStepInto
nmap <Plug>(ide-debugger-step-out) <Plug>VimspectorStepOut
nmap <Plug>(ide-debugger-run-to-cursor) <Plug>VimspectorRunToCursor
nmap <Plug>(ide-debugger-eval-popup) <Plug>VimspectorBalloonEval
nmap <Plug>(ide-debugger-up-frame) <Plug>VimspectorUpFrame
nmap <Plug>(ide-debugger-down-frame) <Plug>VimspectorDownFrame
xmap <Plug>(ide-debugger-eval-popup) <Plug>VimspectorBalloonEval
command! VimspectorClearBreakpoints call vimspector#ClearBreakpoints()
command! VimspectorListBreakpoints call vimspector#ListBreakpoints()

let g:vimspector_sign_priority = {
      \    'vimspectorBP':         999,
      \    'vimspectorBPCond':     999,
      \    'vimspectorBPDisabled': 999,
      \ }

sign define vimspectorBP text=● texthl=IdeBreakpointSign numhl=IdeBreakpointLineNr
sign define vimspectorBPCond text=◆ texthl=IdeBreakpointSign numhl=IdeBreakpointLineNr
sign define vimspectorBPDisabled text=● texthl=LineNr
sign define vimspectorPCBP text=●▶ linehl=CursorLine texthl=IdeCodeWindowCurrentFrameSign linehl=IdeCodeWindowCurrentFrameLineNr
sign define vimspectorPC text=▶ linehl=CursorLine texthl=IdeCodeWindowCurrentFrameSign linehl=IdeCodeWindowCurrentFrameLineNr
sign define vimspectorCurrentThread text=▶ linehl=CursorLine texthl=IdeCodeWindowCurrentFrameSign
sign define vimspectorCurrentFrame text=▶ linehl=CursorLine texthl=IdeCodeWindowCurrentFrameSign

augroup VimspectorSettings
  autocmd!

  autocmd User VimspectorUICreated windo doautocmd User IDEDebuggerMapsNeeded
  autocmd User VimspectorJumpedToFrame doautocmd User IDEDebuggerMapsNeeded
  autocmd User VimspectorJumpedToFrame normal zz
augroup END
