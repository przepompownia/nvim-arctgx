local git = require('arctgx.git')
local gs = require('gitsigns')

local gitsigns = {}

---@param repoParams table<integer, {toplevel: string, gitdir: string}>
---@return function
gitsigns.tryWorktrees = function (repoParams)
  return function(bufnr, callback)
    local file = vim.api.nvim_buf_get_name(bufnr)

    for _, worktree in ipairs(repoParams) do
      if git.isTracked(file, worktree.gitdir, worktree.toplevel) then
        callback ({
          toplevel = worktree.toplevel,
          gitdir = worktree.gitdir,
        })
        return
      end
    end

    callback()
  end
end

gitsigns.configuration = {
  -- _signs_staged_enable = true,
  -- _refresh_staged_on_update = true,
  on_attach = function(bufnr)
    local function map(modes, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(modes, l, r, opts)
    end

    map('n', ']c', function()
      pcall(vim.fn['repeat#set'], ']c', -1)
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      pcall(vim.fn['repeat#set'], '[c', -1)
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n'}, '<Plug>(ide-git-hunk-stage)', gs.stage_hunk)
    map({'n'}, '<Plug>(ide-git-hunk-reset)', gs.reset_hunk)
    map({'v'}, '<Plug>(ide-git-hunk-stage)', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map({'v'}, '<Plug>(ide-git-hunk-reset)', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<Plug>(ide-git-stage-write-file)', gs.stage_buffer)
    map({'n', 'v'}, '<Plug>(ide-git-hunk-undo-stage)', gs.undo_stage_hunk)
    map('n', '<Plug>(ide-git-buffer-reset)', gs.reset_buffer)
    map('n', '<Plug>(ide-git-hunk-print)', gs.preview_hunk)
    map('n', '<Plug>(ide-git-hunk-print-inline)', gs.preview_hunk_inline)
    map('n', '<Plug>(ide-git-blame-line)', function() gs.blame_line{full=true} end)
    map('n', '<Plug>(ide-git-blame-toggle-virtual)', gs.toggle_current_line_blame)
    map('n', '<Plug>(ide-git-highlight-toggle)', gs.toggle_linehl)
    map('n', '<Plug>(ide-git-diffthis)', gs.diffthis)
    map('n', '<Plug>(ide-git-diffthis-previous)', function() gs.diffthis('~') end)
    map('n', '<Plug>(ide-git-toggle-deleted)', gs.toggle_deleted)
    map('n', '<Plug>(ide-git-hunk-visual-selection)', gs.select_hunk)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

return gitsigns
