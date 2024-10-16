local api = vim.api

local git = require('arctgx.git')
local gs = require('gitsigns')

local gitsigns = {}

--- @param repoParams table<integer, {toplevel: string, gitdir: string}>
--- @return function
gitsigns.tryWorktrees = function (repoParams)
  return function (bufnr, callback)
    local file = api.nvim_buf_get_name(bufnr)

    for _, worktree in ipairs(repoParams) do
      if git.isTracked(file, worktree.gitdir, worktree.toplevel) then
        callback({
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
  attach_to_untracked = true,
  on_attach = function (bufnr)
    local keymap = require('arctgx.vim.abstractKeymap')
    local function map(modes, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      keymap.set(modes, l, r, opts)
    end

    map('n', 'jumpToNextDiffOrGitHunk', keymap.repeatable(function ()
      if vim.wo.diff then
        api.nvim_feedkeys(']c', 'n', false)
        return '<Ignore>'
      end
      vim.schedule(function () gs.next_hunk() end)
      return '<Ignore>'
    end), {expr = true})

    map('n', 'jumpToPreviousDiffOrGitHunk', keymap.repeatable(function ()
      if vim.wo.diff then
        api.nvim_feedkeys('[c', 'n', false)
        return '<Ignore>'
      end
      vim.schedule(function () gs.prev_hunk() end)
      return '<Ignore>'
    end), {expr = true})

    map({'n'}, 'gitHunkStage', gs.stage_hunk)
    map({'v'}, 'gitHunkStage', function () gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map({'n'}, 'gitHunkReset', gs.reset_hunk)
    map({'v'}, 'gitHunkReset', function () gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', 'gitStageAndWriteFile', gs.stage_buffer)
    map({'n', 'v'}, 'gitHunkUndoStage', gs.undo_stage_hunk)
    map('n', 'gitBufferReset', gs.reset_buffer)
    map('n', 'gitHunkPreview', gs.preview_hunk)
    map('n', 'gitHunkPrintInline', gs.preview_hunk_inline)
    map('n', 'gitBlameLine', function () gs.blame_line {full = true} end)
    map('n', 'gitBlame', gs.blame)
    map('n', 'gitBlameToggleVirtual', gs.toggle_current_line_blame)
    map('n', 'gitToggleHighlight', gs.toggle_linehl)
    map('n', 'gitDiffAgainstIndex', gs.diffthis)
    map('n', 'gitDiffAgainstLastCommit', function () gs.diffthis('~') end)
    map('n', 'gitToggleDeleted', gs.toggle_deleted)
    map('n', 'gitHunkToVisual', gs.select_hunk)
  end
}

return gitsigns
