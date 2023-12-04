local keymap = require('arctgx.vim.keymap')
local api = vim.api

---@type AbstractKeymaps
local abstractKeymaps = {
  shellOpen = {lhs = {'<F8>'}, desc = 'Open shell window, mostly with dirname of current buffer as CWD'},
  diagnosticSetLocList = {lhs = {'<Space>q'}},
  diagnosticOpenFloat = {lhs = {'<Leader>ii'}},
  diagnosticGotoPrevious = {lhs = {'[d'}},
  diagnosticGotoNext = {lhs = {']d'}},
  browseWindows = {lhs = '<F1>', desc = 'Browse windows'},
  browseBuffers = {lhs = '<S-F1>', desc = 'Browse buffers'},
  browseOldfiles = {lhs = '<F4>', desc = 'Browse oldfiles'},
  browseOldfilesInCwd = {lhs = '<Leader><F4>', desc = 'Browse oldfiles under CWD'},
  browseGitBranches = {lhs = '<S-F4>', desc = 'Browse git branches'},
  browseCommandHistory = {lhs = '<Leader>;', desc = 'Browse command history'},
  grepGit = {lhs = '<F12>', desc = 'Pick by git grep'},
  grepAll = {lhs = '<S-F12>', desc = 'Pick by ripgrep'},
  filesGit = {lhs = '<F11>', desc = 'Pick files from git repo'},
  filesAll = {lhs = '<S-F12>', desc = 'Pick all files'},
  searchStringFromTextObject = {lhs = '<Leader>q', desc = 'Search string from textobject'},
  searchStringInGitFromTextObject = {lhs = '<Leader>w', desc = 'Search string from textobject in git repo'},
  searchStringInFilenamesFromTextObject = {lhs = '<Leader>ff', desc = 'Search string from textobject in finenames'},
  searchStringInGitFilenamesFromTextObject = {lhs = '<Leader>fg', desc = 'Search string from textobject in git finenames'},
  debuggerRun = {lhs = '<Leader>dr', desc = 'Debugger: run'},
  debuggerStepOver = {lhs = '<Leader>ds', desc = 'Debugger: step over'},
  debuggerStepInto = {lhs = '<Leader>di', desc = 'Debugger: step into'},
  debuggerStepOut = {lhs = '<Leader>do', desc = 'Debugger: step out'},
  debuggerClose = {lhs = '<Leader>dq', desc = 'Debugger: close'},
  debuggerClean = {lhs = '<Leader>dQ', desc = 'Debugger: clean'},
  -- debuggerDetach = {lhs = '<Leader><S-F6>', desc = 'Debugger: detach'},
  debuggerRunToCursor = {lhs = '<Leader>dC', desc = 'Debugger: run to cursor'},
  debuggerEvalToFloat = {lhs = '<Leader>dp', desc = 'Debugger: evaluate and show the result in float window'},
  debuggerFrameUp = {lhs = '<Leader>dk', desc = 'Debugger: '},
  debuggerFrameDown = {lhs = '<Leader>dj', desc = 'Debugger: '},
  debuggerSetLogBreakpoint = {lhs = '<Leader>dl', desc = 'Debugger: set log breakpoint'},
  debuggerJumpToUI = {lhs = '<Leader>dw', desc = 'Debugger: jump to UI if exists'},
  debuggerAddToWatched = {lhs = '<Leader>dW', desc = 'Debugger: add expression to watchlist'},
  debuggerCloseUI = {lhs = '<Leader>dc', desc = 'Debugger: close UI'},
  debuggerUIToggle = {lhs = '<Leader><S-F5>', desc = 'Debugger: UI toggle'},
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
}

require('arctgx.vim.abstractKeymap').load(abstractKeymaps)

---@type KeyToPlugMappings
local keyToPlugMappings = {
  ['<C-\\>,'] = {rhs = '<Plug>(ide-show-signature-help)', modes = {'i'}},
  ['<Leader>ish'] = {rhs = '<Plug>(ide-show-signature-help)', modes = {'n'}},
  ['<C-Space>'] = {rhs = '<Plug>(ide-trigger-completion)', modes = {'i'}},
  ['<C-]>'] = {rhs = '<Plug>(ide-goto-definition)', modes = {'n'}},
  ['gd'] = {rhs = '<Plug>(ide-goto-definition)', modes = {'n'}},
  ['gyd'] = {rhs = '<Plug>(ide-goto-definition-in-place)', modes = {'n'}},
  ['gD'] = {rhs = '<Plug>(ide-peek-definition-ts)', modes = {'n'}},
  ['<C-LeftMouse>'] = {rhs = '<Plug>(ide-goto-definition)', modes = {'n'}},
  ['g<LeftMouse>'] = {rhs = '<Plug>(ide-goto-definition)', modes = {'n'}},
  ['<Leader>icn'] = {rhs = '<Plug>(ide-class-new)', modes = {'n'}},
  ['gi'] = {rhs = '<Plug>(ide-goto-implementation)', modes = {'n'}},
  ['gr'] = {rhs = '<Plug>(ide-find-references)', modes = {'n'}},
  ['<Leader>ih'] = {rhs = '<Plug>(ide-toggle-inlay-hints)', modes = {'n'}},
  ['<space>f'] = {rhs = '<Plug>(ide-format-with-all-formatters)', modes = {'n', 'v'}},
  ['<space>F'] = {rhs = '<Plug>(ide-format-with-selected-formatter)', modes = {'n', 'v'}},
  ['<Leader>iaf'] = {rhs = '<Plug>(ide-action-fold)', modes = {'n'}},
  ['<Leader>iar'] = {rhs = '<Plug>(ide-action-rename)', modes = {'n'}},
  ['<F6>'] = {rhs = '<Plug>(ide-list-document-symbols)', modes = {'n'}},
  ['<Leader>ilo'] = {rhs = '<Plug>(ide-list-document-symbols)', modes = {'n'}},
  ['<Leader>ilw'] = {rhs = '<Plug>(ide-list-workspace-symbols)', modes = {'n'}},
  [']]'] = {rhs = '<Plug>(ide-move-forward-function-start)', modes = {'n'}},
  [']['] = {rhs = '<Plug>(ide-move-forward-function-end)', modes = {'n'}},
  [']m'] = {rhs = '<Plug>(ide-move-forward-class-start)', modes = {'n'}},
  [']M'] = {rhs = '<Plug>(ide-move-forward-class-end)', modes = {'n'}},
  ['[['] = {rhs = '<Plug>(ide-move-backward-function-start)', modes = {'n'}},
  ['[]'] = {rhs = '<Plug>(ide-move-backward-function-end)', modes = {'n'}},
  ['[m'] = {rhs = '<Plug>(ide-move-backward-class-start)', modes = {'n'}},
  ['[M'] = {rhs = '<Plug>(ide-move-backward-class-end)', modes = {'n'}},
  ['if'] = {rhs = '<Plug>(ide-select-function-inner)', modes = {'x'}},
  ['af'] = {rhs = '<Plug>(ide-select-function-outer)', modes = {'x'}},
  ['<Leader>a'] = {rhs = '<Plug>(ide-parameter-swap-forward)', repeatable = true, modes = {'n'}},
  ['<Leader>A'] = {rhs = '<Plug>(ide-parameter-swap-backward)', repeatable = true, modes = {'n'}},
  ['iC'] = {rhs = '<Plug>(ide-select-class-inner)', modes = {'x', 'o'}},
  ['aC'] = {rhs = '<Plug>(ide-select-class-outer)', modes = {'x', 'o'}},
  ['<Leader>sfa'] = {rhs = '<Plug>(ide-workspace-folder-add)', modes = {'n'}},
  ['<Leader>sfd'] = {rhs = '<Plug>(ide-workspace-folder-remove)', modes = {'n'}},
  ['<Leader>sfl'] = {rhs = '<Plug>(ide-workspace-folder-list)', modes = {'n'}},
  ['<Leader>ca'] = {rhs = '<Plug>(ide-code-action)', modes = {'n'}},

  ['<Leader>t'] = {rhs = '<Plug>(treesitter-init-selection)', modes = {'n'}},
  ['<Leader>]'] = {rhs = '<Plug>(treesitter-node-incremental)', modes = {'v'}},
  ['<Leader>['] = {rhs = '<Plug>(treesitter-node-decremental)', modes = {'v'}},
  ['<Leader><Leader>]'] = {rhs = '<Plug>(treesitter-scope-incremental)', modes = {'v'}},
}

---@type KeyToPlugMappings
local globalMappings = {
  ['<Leader>hs'] = {rhs = '<Plug>(ide-git-hunk-stage)', modes = {'n', 'v'}},
  ['<Leader>g'] = {rhs = '<Plug>(ide-git-status-open)', modes = {'n'}},
  ['<Leader>gc'] = {rhs = '<Plug>(ide-git-commit)', modes = {'n'}},
  ['<Leader>gb'] = {rhs = '<Plug>(ide-git-blame)', modes = {'n'}},
  ['<Leader>gs'] = {rhs = '<Plug>(ide-git-status-open)', modes = {'n'}},
  ['<Leader>gq'] = {rhs = '<Plug>(ide-git-status-close)', modes = {'n'}},
  ['<Leader>gl'] = {rhs = '<Plug>(ide-git-log-current-file)', modes = {'n'}},
  ['<Leader>gL'] = {rhs = '<Plug>(ide-git-log-all-files)', modes = {'n'}},
  ['<Leader>gp'] = {rhs = '<Plug>(ide-git-push-all)', modes = {'n'}},
  ['<Leader>hu'] = {rhs = '<Plug>(ide-git-hunk-undo-stage)', modes = {'n', 'v'}},
  ['<Leader>hr'] = {rhs = '<Plug>(ide-git-hunk-reset)', modes = {'n'}},
  ['<Leader>hv'] = {rhs = '<Plug>(ide-git-hunk-visual-selection)', modes = {'n'}},
  ['<Leader>hR'] = {rhs = '<Plug>(ide-git-buffer-reset)', modes = {'n'}},
  ['<Leader>hp'] = {rhs = '<Plug>(ide-git-hunk-print)', modes = {'n'}},
  ['<Leader>hP'] = {rhs = '<Plug>(ide-git-hunk-print-inline)', modes = {'n'}},
  ['<Leader>ht'] = {rhs = '<Plug>(ide-git-highlight-toggle)', modes = {'n'}},
  ['<Leader>hT'] = {rhs = '<Plug>(ide-git-toggle-deleted)', modes = {'n'}},
  ['<Leader>hb'] = {rhs = '<Plug>(ide-git-blame-line)', modes = {'n'}},
  ['<Leader>hB'] = {rhs = '<Plug>(ide-git-blame-toggle-virtual)', modes = {'n'}},
  ['<Leader>hd'] = {rhs = '<Plug>(ide-git-diffthis)', modes = {'n'}},
  ['<Leader>hD'] = {rhs = '<Plug>(ide-git-diffthis-previous)', modes = {'n'}},

  ['<S-F2>'] = {rhs = '<Plug>(ide-git-stage-write-file)', modes = {'n'}},
  ['[h'] = {rhs = '<Plug>(ide-git-hunk-previous)', modes = {'n'}},
  [']h'] = {rhs = '<Plug>(ide-git-hunk-next)', modes = {'n'}},


  ['<F5>'] = {rhs = '<Plug>(ide-db-ui-toggle)', modes = {'n'}},

  ['<Leader>m'] = {rhs = '<Plug>(ide-tree-focus-current-file)', modes = {'n'}, desc = 'File tree: focus current buffer'},
  ['<Leader>iwb'] = {rhs = '<Plug>(ide-write-backup)', modes = {'n'}},

  ['<Esc>'] = {rhs = '<Plug>(ide-close-popup)'},
}

keymap.loadKeyToPlugMappings(globalMappings)

local augroup = api.nvim_create_augroup('IdeMapsLua', {clear = true})
api.nvim_create_autocmd({'FileType'}, {
  group = augroup,
  callback = function (params)
    local excludedFiletypes = {'help', 'man', 'dbout', 'dapui_hover', 'noice'}
    if vim.tbl_contains(excludedFiletypes, params.match) then
      return
    end

    keymap.loadKeyToPlugMappings(keyToPlugMappings, params.buf)
  end,
})
