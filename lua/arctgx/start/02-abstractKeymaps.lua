--- @type AbstractKeymaps
local abstractKeymaps = {
  shellOpen = {lhs = {'<F8>'}, desc = 'Open shell window, mostly with dirname of current buffer as CWD'},
  pickerOverview = {lhs = '<F9>', desc = 'Picker overview'},
  previewJumps = {lhs = '<F7>', desc = 'Preview jumps'},
  diagnosticSetLocList = {lhs = {'<Space>q'}, desc = 'Diagnostic: set location list'},
  browseWindows = {lhs = '<Leader><F1>', desc = 'Browse windows'},
  browseAllBuffers = {lhs = {'<S-F1>', '<F13>'}, desc = 'Browse all loaded buffers'},
  browseBuffersInCwd = {lhs = '<F1>', desc = 'Browse buffers in CWD'},
  browseOldfilesInCwd = {lhs = '<F4>', desc = 'Browse oldfiles under CWD'},
  browseOldfiles = {lhs = '<Leader><F4>', desc = 'Browse oldfiles'},
  browseGitBranches = {lhs = {'<S-F4>', '<F16>'}, desc = 'Browse git branches'},
  browseCommandHistory = {lhs = '<Leader>;', desc = 'Browse command history'},
  browseNotificationHistory = {lhs = '<Leader>nh', desc = 'Browse notification history'},
  filesGit = {lhs = '<F11>', desc = 'Pick files from git repo'},
  filesAll = {lhs = {'<S-F11>', '<F23>'}, desc = 'Pick all files'},
  grepGit = {lhs = '<F12>', desc = 'Pick by git grep'},
  grepAll = {lhs = {'<S-F12>', '<F24>'}, desc = 'Pick by ripgrep'},
  searchStringFromTextObject = {lhs = '<Leader>q', desc = 'Search string from textobject'},
  searchStringInGitFromTextObject = {lhs = '<Leader>w', desc = 'Search string from textobject in git repo'},
  searchStringInFilenamesFromTextObject = {lhs = '<Leader>ff', desc = 'Search string from textobject in finenames'},
  searchStringInGitFilenamesFromTextObject = {lhs = '<Leader>fg', desc = 'Search string from textobject in git finenames'},
  debuggerRun = {lhs = '<Leader>dr', desc = 'Debugger: run'},
  debuggerStepOver = {lhs = '<Leader>ds', desc = 'Debugger: step over'},
  debuggerStepInto = {lhs = '<Leader>di', desc = 'Debugger: step into'},
  debuggerStepOut = {lhs = '<Leader>do', desc = 'Debugger: step out'},
  debuggerClose = {lhs = '<Leader>dq', desc = 'Debugger: close'},
  debuggerTerminate = {lhs = '<Leader>dT', desc = 'Debugger: terminate'},
  debuggerClean = {lhs = '<Leader>dQ', desc = 'Debugger: clean'},
  -- debuggerDetach = {lhs = '<Leader><S-F6>', desc = 'Debugger: detach'},
  debuggerRunToCursor = {lhs = '<Leader>dC', desc = 'Debugger: run to cursor'},
  debuggerEvalToFloat = {lhs = '<Leader>dp', desc = 'Debugger: evaluate and show the result in float window'},
  debuggerFrameUp = {lhs = '<Leader>dk', desc = 'Debugger: frame up'},
  debuggerFrameDown = {lhs = '<Leader>dj', desc = 'Debugger: frame down'},
  debuggerSetLogBreakpoint = {lhs = '<Leader>dl', desc = 'Debugger: set log breakpoint'},
  debuggerJumpToUI = {lhs = '<Leader>dw', desc = 'Debugger: jump to UI if exists'},
  debuggerAddToWatched = {lhs = '<Leader>dW', desc = 'Debugger: add expression to watchlist'},
  debuggerCloseUI = {lhs = '<Leader>dc', desc = 'Debugger: close UI'},
  debuggerUIToggle = {lhs = {'<Leader><S-F5>', '<Leader><F17>'}, desc = 'Debugger: UI toggle'},
  debuggerClearBreakpoints = {lhs = '<Leader>db', desc = 'Debugger: clear breakpoints'},
  debuggerToggleBreakpoint = {lhs = '<Leader>dt', desc = 'Debugger: set breakpoint'},
  debuggerSetBreakpointConditional = {lhs = '<Leader>dT', desc = 'Debugger: set conditional breakpoint'},
  testUIToggleSummary = {lhs = '<Leader>us', desc = 'Test UI: toggle summary'},
  testUIToggleOutput = {lhs = '<Leader>uo', desc = 'Test UI: toggle output'},
  testUIRunNearest = {lhs = '<Leader>ur', desc = 'Test UI: run nearest test case'},
  testUIRunNearestWithDap = {lhs = '<Leader>ud', desc = 'Test UI: run nearest test case with DAP strategy'},
  splitLinesAtCursor = {lhs = '[oj', desc = 'Split lines at cursor'},
  joinLinesAtCursor = {lhs = ']oj', desc = 'Join lines at cursor'},
  toggleSplitJoinLinesAtCursor = {lhs = 'yoj', desc = 'Toggle split/join lines at cursor'},
  jumpToPreviousDiffOrGitHunk = {lhs = '[c', desc = 'Jump to previous diff or git hunk'},
  jumpToNextDiffOrGitHunk = {lhs = ']c', desc = 'Jump to next diff or git hunk'},
  gitHunkStage = {lhs = '<Leader>hs', desc = 'Git: stage hunk'},
  gitStatusUIOpen = {lhs = {'<Leader>gg'}, desc = 'Git: open status UI'},
  gitStatusUIClose = {lhs = '<Leader>gq', desc = 'Git: close status UI'},
  gitCommit = {lhs = '<Leader>gc', desc = 'Git: commit'},
  gitBlame = {lhs = '<Leader>gb', desc = 'Git: blame whole buffer'},
  gitLogCurrentFile = {lhs = '<Leader>gl', desc = 'Git: log current file'},
  gitLogAllFiles = {lhs = '<Leader>gL', desc = 'Git: log all files'},
  gitPush = {lhs = '<Leader>gp', desc = 'Git: push'},
  gitHunkUndoStage = {lhs = '<Leader>hu', desc = 'Git: undo stage hunk'},
  gitHunkReset = {lhs = '<Leader>hr', desc = 'Git: reset hunk'},
  gitHunkToVisual = {lhs = '<Leader>hv', desc = 'Git: create visual selection from hunk'},
  gitBufferReset = {lhs = '<Leader>hR', desc = 'Git: reset buffer'},
  gitHunkPreview = {lhs = '<Leader>hp', desc = 'Git: print hunk'},
  gitHunkPrintInline = {lhs = '<Leader>hP', desc = 'Git: print hunk inline'},
  gitToggleHighlight = {lhs = '<Leader>ht', desc = 'Git: toggle highlight'},
  gitToggleDeleted = {lhs = '<Leader>hT', desc = 'Git: toggle displaying deleted lines'},
  gitBlameLine = {lhs = '<Leader>hb', desc = 'Git: blame line under cursor'},
  gitBlameToggleVirtual = {lhs = '<Leader>hB', desc = 'Git: toggle displaying blame in virtual lines'},
  gitDiffAgainstIndex = {lhs = '<Leader>hd', desc = 'Git: diff against the index'},
  gitDiffAgainstLastCommit = {lhs = '<Leader>hD', desc = 'Git: diff against the last commit'},
  gitStageAndWriteFile = {lhs = {'<S-F2>', '<F14>'}, desc = 'Git: stage and write file'},
  writeBackup = {lhs = '<Leader>iwb', desc = 'Write backup file'},
  dbToggleUI = {lhs = '<F5>', desc = 'Toggle database UI'},
  fileTreeFocus = {lhs = '<Leader>m', desc = 'File tree: focus current buffer'},
  langGoToDefinition = {lhs = {'<C-]>', 'gd', '<C-LeftMouse>', 'g<LeftMouse>'}, desc = 'Go to definition'},
  langGoToDefinitionInPlace = {lhs = {'gyd'}, desc = 'Go to definition in place'},
  -- langPeekDefinition = {lhs = {'gD'}, desc = 'Show definition in float window'},
  langGoToTypeDefinition = {lhs = 'gyD', desc = 'Go to type definition'},
  langGoToImplementation = {lhs = {'gi'}, desc = 'Find implementations'},
  langFindWorkspaceSymbols = {lhs = {'<S-F6>', '<F18>'}, desc = 'Find workspace symbols'},
  langToggleInlayHints = {lhs = '<Leader>ih', desc = 'Toggle inlay hints'},
  langTriggerCompletion = {lhs = '<C-Space>', desc = 'Trigger completion'},
  langApplyAllformatters = {lhs = '<Space>f', desc = 'Apply all formatters'},
  langApplySelectedformatter = {lhs = '<Space>F', desc = 'Select formatter'},
  langWorkspaceFolderList = {lhs = '<Leader>sfl', desc = 'List workspace folders'},
  langWorkspaceFolderAdd = {lhs = '<Leader>sfa', desc = 'Add workspace folder'},
  langWorkspaceFolderRemove = {lhs = '<Leader>sfd', desc = 'Remove workspace folder'},
  langClassNew = {lhs = '<Leader>icn', desc = 'New class'},
  langIncrementSelection = {lhs = '<A-]>', desc = 'Increment selection based on language'},
  langScopeIncrementSelection = {lhs = '<Leader>]', desc = 'Increment selection based on language'},
  langDecrementSelection = {lhs = '<A-[>', desc = 'Decrement selection based on language'},

  langShowSignatureHelp = {lhs = {i = '<C-Bslash>,', n = '<Leader>ish'}, desc = 'Show signature help'},
  langFindReferences = {lhs = {'gr', 'grr'}, desc = 'Find references'},
  langRenameSymbol = {lhs = '<Leader>r', desc = 'Rename symbol'},
  langCodeAction = {lhs = '<Leader>ca', desc = 'Code action'},
}

require('arctgx.vim.abstractKeymap').load(abstractKeymaps)
