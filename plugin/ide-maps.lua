local keymap = require('arctgx.vim.keymap')
local api = vim.api

---@type KeyToPlugMappings
local keyToPlugMappings = {
  ['<Leader>dr'] = {rhs = '<Plug>(ide-debugger-run)', repeatable = true},
  ['<Leader>ds'] = {rhs = '<Plug>(ide-debugger-step-over)', repeatable = true},
  ['<Leader>di'] = {rhs = '<Plug>(ide-debugger-step-into)', repeatable = true},
  ['<Leader>do'] = {rhs = '<Plug>(ide-debugger-step-out)', repeatable = true},
  ['<Leader>dq'] = {rhs = '<Plug>(ide-debugger-close)'},
  ['<Leader>dQ'] = {rhs = '<Plug>(ide-debugger-clean)'},
  ['<Leader><S-F6>'] = {rhs = '<Plug>(ide-debugger-detach)'},
  ['<Leader><F9>'] = {rhs = '<Plug>(ide-debugger-run-to-cursor)'},
  ['<Leader>dp'] = {
    rhs = '<Plug>(ide-debugger-eval-popup)',
    repeatable = false,
    modes = {'n', 'x'},
  },
  ['<Leader>dk'] = {rhs = '<Plug>(ide-debugger-up-frame)', repeatable = true},
  ['<Leader>dj'] = {rhs = '<Plug>(ide-debugger-down-frame)', repeatable = true},
  ['<Leader>dw'] = {rhs = '<Plug>(ide-debugger-go-to-view)'},
  ['<Leader>dW'] = {rhs = '<Plug>(ide-debugger-ui-add-to-watch)'},
  ['<Leader>dc'] = {rhs = '<Plug>(ide-debugger-close-view)'},
  ['<F6>'] = {rhs = '<Plug>(ide-list-document-symbols)', modes = {'n'}},
  ['<Leader><S-F5>'] = {rhs = '<Plug>(ide-debugger-ui-toggle)', modes = {'n'}},
  ['<Leader>dt'] = {rhs = '<Plug>(ide-debugger-toggle-breakpoint)', repeatable = true, modes = {'n'}},
  ['<Leader><S-F10>'] = {
    rhs = '<Plug>(ide-debugger-toggle-breakpoint-conditional)',
    modes = {'n'},
  },
  ['<Leader>db'] = {rhs = '<Plug>(ide-debugger-clear-breakpoints)', modes = {'n'}},

  ['[oj'] = {rhs = '<Plug>(ide-toggle-split-lines-at-cursor)', modes = {'n'}},
  [']oj'] = {rhs = '<Plug>(ide-toggle-join-lines-at-cursor)', modes = {'n'}},
  ['yoj'] = {rhs = '<Plug>(ide-toggle-split-join-lines-at-cursor)', modes = {'n'}, repeatable = true},
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
  ['<Leader>ii'] = {rhs = '<Plug>(ide-diagnostic-info)', modes = {'n'}},
  ['[d'] = {rhs = '<Plug>(ide-diagnostic-goto-previous)', modes = {'n'}},
  [']d'] = {rhs = '<Plug>(ide-diagnostic-goto-next)', modes = {'n'}},
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
  ['<Leader>fg'] = {rhs = '<Plug>(ide-git-files-search-operator)', modes = {'n', 'v'}},

  ['<Leader>q'] = {rhs = '<Plug>(ide-grep-string-search-operator)', modes = {'v', 'n'}},
  ['<Leader>w'] = {rhs = '<Plug>(ide-git-string-search-operator)', modes = {'v', 'n'}},
  ['<S-F2>'] = {rhs = '<Plug>(ide-git-stage-write-file)', modes = {'n'}},
  ['[h'] = {rhs = '<Plug>(ide-git-hunk-previous)', modes = {'n'}},
  [']h'] = {rhs = '<Plug>(ide-git-hunk-next)', modes = {'n'}},

  ['<Leader>ff'] = {rhs = '<Plug>(ide-files-search-operator)', modes = {'n', 'v'}},

  ['<S-F1>'] = {rhs = '<Plug>(ide-browse-buffers)', modes = {'n'}},
  ['<Leader>;'] = {rhs = '<Plug>(ide-browse-cmd-history)', modes = {'n'}},
  ['<F4>'] = {rhs = '<Plug>(ide-browse-history)', modes = {'n'}},
  ['<Leader><F4>'] = {rhs = '<Plug>(ide-browse-history-in-cwd)', modes = {'n'}},
  ['<S-F4>'] = {rhs = '<Plug>(ide-git-show-branches)', modes = {'n'}},
  ['<F5>'] = {rhs = '<Plug>(ide-db-ui-toggle)', modes = {'n'}},
  ['<F1>'] = {rhs = '<Plug>(ide-browse-windows)', modes = {'n'}},
  ['<F11>'] = {rhs = '<Plug>(ide-browse-gfiles)', modes = {'n'}},
  ['<S-F11>'] = {rhs = '<Plug>(ide-browse-files)', modes = {'n'}},
  ['<F12>'] = {rhs = '<Plug>(ide-grep-git)', modes = {'n'}},
  ['<S-F12>'] = {rhs = '<Plug>(ide-grep-files)', modes = {'n'}},

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
