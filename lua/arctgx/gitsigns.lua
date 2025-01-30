local api = vim.api

local git = require('arctgx.git')
local gs = require('gitsigns')
local keymap = require('arctgx.vim.abstractKeymap')

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

--- @type Gitsigns.Config
gitsigns.configuration = {
  debug_mode = true,
  attach_to_untracked = true,
  on_attach = function (bufnr)
    local opts = {buffer = bufnr}

    keymap.set('n', 'jumpToNextDiffOrGitHunk', function ()
      if vim.wo.diff then
        api.nvim_feedkeys(']c', 'n', false)
        return '<Ignore>'
      end
      vim.schedule(function () gs.nav_hunk('next', {preview = true}) end)
      return '<Ignore>'
    end, opts)

    keymap.set('n', 'jumpToPreviousDiffOrGitHunk', function ()
      if vim.wo.diff then
        api.nvim_feedkeys('[c', 'n', false)
        return '<Ignore>'
      end
      vim.schedule(function () gs.nav_hunk('prev', {preview = true}) end)
      return '<Ignore>'
    end, opts)

    keymap.set({'n'}, 'gitHunkStage', gs.stage_hunk, opts)
    keymap.set({'v'}, 'gitHunkStage', function () gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, opts)
    keymap.set({'n'}, 'gitHunkReset', gs.reset_hunk, opts)
    keymap.set({'v'}, 'gitHunkReset', function () gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, opts)
    keymap.set('n', 'gitStageAndWriteFile', gs.stage_buffer, opts)
    keymap.set('n', 'gitBufferReset', gs.reset_buffer, opts)
    keymap.set('n', 'gitHunkPreview', gs.preview_hunk, opts)
    keymap.set('n', 'gitHunkPrintInline', gs.preview_hunk_inline, opts)
    keymap.set('n', 'gitBlameLine', function () gs.blame_line {full = true} end, opts)
    keymap.set('n', 'gitBlame', gs.blame, opts)
    keymap.set('n', 'gitBlameToggleVirtual', gs.toggle_current_line_blame, opts)
    keymap.set('n', 'gitToggleHighlight', gs.toggle_linehl, opts)
    keymap.set('n', 'gitDiffAgainstIndex', gs.diffthis, opts)
    keymap.set('n', 'gitDiffAgainstLastCommit', function () gs.diffthis('~') end, opts)
    keymap.set('n', 'gitHunkToVisual', gs.select_hunk, opts)
  end
}

api.nvim_create_autocmd('User', {
  pattern = 'GitSignsUpdate',
  callback = function ()
    api.nvim__redraw({statusline = true})
  end
})

return gitsigns
