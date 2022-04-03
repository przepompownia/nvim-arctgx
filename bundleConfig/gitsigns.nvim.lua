require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(modes, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(modes, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<Plug>(ide-git-hunk-stage)', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<Plug>(ide-git-hunk-reset)', ':Gitsigns reset_hunk<CR>')
    map('n', '<Plug>(ide-git-stage-write-file)', gs.stage_buffer)
    map('n', '<Plug>(ide-git-hunk-undo-stage)', gs.undo_stage_hunk)
    map('n', '<Plug>(ide-git-buffer-reset)', gs.reset_buffer)
    map('n', '<Plug>(ide-git-hunk-print)', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
