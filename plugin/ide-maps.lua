local keymap = require('arctgx.vim.keymap')
local api = vim.api

---@type KeyToPlugMappings
local keyToPlugMappings = {
  ['<Leader>dr'] = {rhs = '<Plug>(ide-debugger-run)', repeatable = true},
  ['<Leader>ds'] = {rhs = '<Plug>(ide-debugger-step-over)', repeatable = true},
  ['<Leader>di'] = {rhs = '<Plug>(ide-debugger-step-into)', repeatable = true},
  ['<Leader>do'] = {rhs = '<Plug>(ide-debugger-step-out)', repeatable = true},
  ['<Leader>dq'] = {rhs = '<Plug>(ide-debugger-close)'},
  ['<Leader><S-F6>'] = {rhs = '<Plug>(ide-debugger-detach)'},
  ['<Leader><F9>'] = {rhs = '<Plug>(ide-debugger-run-to-cursor)', repeatable = false},
  ['<Leader>dp'] = {
    rhs = '<Plug>(ide-debugger-eval-popup)',
    repeatable = false,
    modes = {'n', 'x'},
  },
  ['<Leader>dk'] = {rhs = '<Plug>(ide-debugger-up-frame)', repeatable = true},
  ['<Leader>dj'] = {rhs = '<Plug>(ide-debugger-down-frame)', repeatable = true},
  ['<Leader>dw'] = {rhs = '<Plug>(ide-debugger-go-to-view)'},
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
  ['<Leader>ih'] = {rhs = '<Plug>(ide-hover)', modes = {'n'}},
  ['K'] = {rhs = '<Plug>(ide-hover)', modes = {'n'}},
  ['<space>f'] = {rhs = '<Plug>(ide-format-with-all-formatters)', modes = {'n', 'v'}},
  ['<space>F'] = {rhs = '<Plug>(ide-format-with-selected-formatter)', modes = {'n', 'v'}},
  ['<Leader>iaf'] = {rhs = '<Plug>(ide-action-fold)', modes = {'n'}},
  ['<Leader>iar'] = {rhs = '<Plug>(ide-action-rename)', modes = {'n'}},
  ['<Leader>ilo'] = {rhs = '<Plug>(ide-list-document-symbols)', modes = {'n'}},
  ['<Leader>ilf'] = {rhs = '<Plug>(ide-list-document-functions)', modes = {'n'}},
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

local globalMappings = {
  ['<Leader>hs'] = {rhs = '<Plug>(ide-git-hunk-stage)', repeatable = false, modes = {'n', 'v'}},
  ['<Leader>g'] = {rhs = '<Plug>(ide-git-status)', repeatable = false, modes = {'n'}},
  ['<Leader>gc'] = {rhs = '<Plug>(ide-git-commit)', repeatable = false, modes = {'n'}},
  ['<Leader>gb'] = {rhs = '<Plug>(ide-git-blame)', repeatable = false, modes = {'n'}},
  ['<Leader>gs'] = {rhs = '<Plug>(ide-git-status)', repeatable = false, modes = {'n'}},
  ['<Leader>gl'] = {rhs = '<Plug>(ide-git-log)', repeatable = false, modes = {'n'}},
  ['<Leader>gp'] = {rhs = '<Plug>(ide-git-push-all)', repeatable = false, modes = {'n'}},
  ['<Leader>hu'] = {rhs = '<Plug>(ide-git-hunk-undo-stage)', repeatable = false, modes = {'n', 'v'}},
  ['<Leader>hr'] = {rhs = '<Plug>(ide-git-hunk-reset)', repeatable = false, modes = {'n'}},
  ['<Leader>hv'] = {rhs = '<Plug>(ide-git-hunk-visual-selection)', repeatable = false, modes = {'n'}},
  ['<Leader>hR'] = {rhs = '<Plug>(ide-git-buffer-reset)', repeatable = false, modes = {'n'}},
  ['<Leader>hp'] = {rhs = '<Plug>(ide-git-hunk-print)', repeatable = false, modes = {'n'}},
  ['<Leader>hP'] = {rhs = '<Plug>(ide-git-hunk-print-inline)', repeatable = false, modes = {'n'}},
  ['<Leader>ht'] = {rhs = '<Plug>(ide-git-highlight-toggle)', repeatable = false, modes = {'n'}},
  ['<Leader>hT'] = {rhs = '<Plug>(ide-git-toggle-deleted)', repeatable = false, modes = {'n'}},
  ['<Leader>hb'] = {rhs = '<Plug>(ide-git-blame-line)', repeatable = false, modes = {'n'}},
  ['<Leader>hB'] = {rhs = '<Plug>(ide-git-blame-toggle-virtual)', repeatable = false, modes = {'n'}},
  ['<Leader>hd'] = {rhs = '<Plug>(ide-git-diffthis)', repeatable = false, modes = {'n'}},
  ['<Leader>hD'] = {rhs = '<Plug>(ide-git-diffthis-previous)', repeatable = false, modes = {'n'}},
  ['<Leader>fg'] = {rhs = '<Plug>(ide-git-files-search-operator)', repeatable = false, modes = {'n', 'v'}},

  ['<Leader>q'] = {rhs = '<Plug>(ide-grep-string-search-operator)', repeatable = false, modes = {'v', 'n'}},
  ['<Leader>w'] = {rhs = '<Plug>(ide-git-string-search-operator)', repeatable = false, modes = {'v', 'n'}},
  ['<S-F2>'] = {rhs = '<Plug>(ide-git-stage-write-file)', repeatable = false, modes = {'n'}},
  ['[h'] = {rhs = '<Plug>(ide-git-hunk-previous)', repeatable = false, modes = {'n'}},
  [']h'] = {rhs = '<Plug>(ide-git-hunk-next)', repeatable = false, modes = {'n'}},

  ['<Leader>ff'] = {rhs = '<Plug>(ide-files-search-operator)', modes = {'n', 'v'}},

  ['gx'] = {rhs = '<Plug>(ide-url-open-operator)', modes = {'n', 'v'}},

  ['<Leader>ibb'] = {rhs = '<Plug>(ide-browse-buffers)', modes = {'n'}},
  ['<S-F1>'] = {rhs = '<Plug>(ide-browse-buffers)', modes = {'n'}},
  ['<Leader>;'] = {rhs = '<Plug>(ide-browse-cmd-history)', modes = {'n'}},
  ['<Leader>ibh'] = {rhs = '<Plug>(ide-browse-history)', modes = {'n'}},
  ['<F4>'] = {rhs = '<Plug>(ide-browse-history)', modes = {'n'}},
  ['<Leader><F4>'] = {rhs = '<Plug>(ide-browse-history-in-cwd)', modes = {'n'}},
  ['<S-F4>'] = {rhs = '<Plug>(ide-git-show-branches)', modes = {'n'}},
  ['<F5>'] = {rhs = '<Plug>(ide-db-ui-toggle)', modes = {'n'}},
  ['<Leader>ibf'] = {rhs = '<Plug>(ide-browse-files)', modes = {'n'}},
  ['<Leader>ibg'] = {rhs = '<Plug>(ide-browse-gfiles)', modes = {'n'}},
  ['<Leader>ibw'] = {rhs = '<Plug>(ide-browse-windows)', modes = {'n'}},
  ['<F1>'] = {rhs = '<Plug>(ide-browse-windows)', modes = {'n'}},
  ['<F11>'] = {rhs = '<Plug>(ide-browse-gfiles)', modes = {'n'}},
  ['<S-F11>'] = {rhs = '<Plug>(ide-browse-files)', modes = {'n'}},
  ['<F12>'] = {rhs = '<Plug>(ide-grep-git)', modes = {'n'}},
  ['<S-F12>'] = {rhs = '<Plug>(ide-grep-files)', modes = {'n'}},

  ['<Leader>igg'] = {rhs = '<Plug>(ide-grep-git)', modes = {'n'}},
  ['<Leader>igf'] = {rhs = '<Plug>(ide-grep-files)', modes = {'n'}},
  ['<Leader>m'] = {rhs = '<Plug>(ide-tree-focus-current-file)', modes = {'n'}},
  ['<Leader>iwb'] = {rhs = '<Plug>(ide-write-backup)', modes = {'n'}},

  ['<Esc>'] = {rhs = '<Plug>(ide-close-popup)'},
}

local sequencesToReuseInInsertMode = {
  '<F1>',
  '<F4>',
  '<F11>',
  '<F12>',
  '<S-F1>',
  '<S-F2>',
  '<S-F4>',
  '<S-F11>',
  '<S-F12>',
}

for _, sequence in ipairs(sequencesToReuseInInsertMode) do
  vim.api.nvim_cmd({cmd = 'inoremap', args = { sequence, '<C-o>' .. sequence }}, {})
end

keymap.loadKeyToPlugMappings(globalMappings)

api.nvim_create_augroup('IdeMapsLua', {clear = true})
api.nvim_create_autocmd({'FileType'}, {
  group = 'IdeMapsLua',
  callback = function(params)
    local excludedFiletypes = {'fern', 'help', 'man', 'dbout', 'dapui_hover', 'fugitive'}
    if vim.tbl_contains(excludedFiletypes, params.match) then
      return
    end

    keymap.loadKeyToPlugMappings(keyToPlugMappings, params.buf)
  end,
})

api.nvim_create_user_command('IDEMapsEdit', vim.fn['arctgx#arctgx#editIDEMaps'], {})
api.nvim_create_user_command('IDEMapsReload', vim.fn['arctgx#arctgx#reloadIDEMaps'], {})
